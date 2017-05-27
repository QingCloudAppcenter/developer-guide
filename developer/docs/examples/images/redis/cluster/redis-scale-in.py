'''
This is just a show-to-work example
'''

import subprocess
import socket
import fcntl
import struct

def get_redis_cluster_info(ip):
    '''
    M: ef07a34ed37a1eb44d43c7a526a91ebc0df9bc0d 192.168.100.12:6379
	   slots:10930-16383 (5454 slots) master
	   1 additional replica(s)
	S: 3a9f443600daedc2828b7854653616e5dc4dc625 192.168.100.7:6379
	   slots: (0 slots) slave
	   replicates ef07a34ed37a1eb44d43c7a526a91ebc0df9bc0d
	S: a7796c2a45c736624a7666ce21cab9ff963c5a1e 192.168.100.9:6379
	   slots: (0 slots) slave
	   replicates e9826f99fe1b786c5ed206a9795f80856b7e5d85
	M: 677044d76f7730c9ecaec34351b941acbbd293f7 192.168.100.11:6379
	   slots:2738-8191 (5454 slots) master
	   1 additional replica(s)
	S: 1975f3e583ff9d6e450972767161d76dac4eacca 192.168.100.10:6379
	   slots: (0 slots) slave
	   replicates 677044d76f7730c9ecaec34351b941acbbd293f7
	M: e9826f99fe1b786c5ed206a9795f80856b7e5d85 192.168.100.8:6379
	   slots:0-2737,8192-10929 (5476 slots) master
	   1 additional replica(s)
	[OK] All nodes agree about slots configuration.
	>>> Check for open slots...
	>>> Check slots coverage...
	[OK] All 16384 slots covered.

	Get meaningful info from above and Convert it to the following:

	{
	'a7796c2a45c736624a7666ce21cab9ff963c5a1e': 
	    {'socket': '192.168.100.9:6379', 'replicates': 'e9826f99fe1b786c5ed206a9795f80856b7e5d85', 'num': '0', 'role': 'S', 'slots': '', 'id': 'a7796c2a45c736624a7666ce21cab9ff963c5a1e'}, 
	'677044d76f7730c9ecaec34351b941acbbd293f7': 
	    {'slots': '2738-8191', 'num': '5454', 'role': 'M', 'id': '677044d76f7730c9ecaec34351b941acbbd293f7', 'socket': '192.168.100.11:6379'}, 
	'1975f3e583ff9d6e450972767161d76dac4eacca': 
	    {'socket': '192.168.100.10:6379', 'replicates': '677044d76f7730c9ecaec34351b941acbbd293f7', 'num': '0', 'role': 'S', 'slots': '', 'id': '1975f3e583ff9d6e450972767161d76dac4eacca'}, 
	'ef07a34ed37a1eb44d43c7a526a91ebc0df9bc0d': 
	    {'slots': '10930-16383', 'num': '5454', 'role': 'M', 'id': 'ef07a34ed37a1eb44d43c7a526a91ebc0df9bc0d', 'socket': '192.168.100.12:6379'}, 
	'e9826f99fe1b786c5ed206a9795f80856b7e5d85': 
	    {'slots': '0-2737,8192-10929', 'num': '5476', 'role': 'M', 'id': 'e9826f99fe1b786c5ed206a9795f80856b7e5d85', 'socket': '192.168.100.8:6379'}, 
	'3a9f443600daedc2828b7854653616e5dc4dc625': 
	    {'socket': '192.168.100.7:6379', 'replicates': 'ef07a34ed37a1eb44d43c7a526a91ebc0df9bc0d', 'num': '0', 'role': 'S', 'slots': '', 'id': '3a9f443600daedc2828b7854653616e5dc4dc625'}
	}
	'''

    # Get master nodes and slots info        
    result = subprocess.check_output(["/opt/redis/bin/redis-trib.rb check %s:6379" % ip], shell=True)
    
    lines = result.splitlines()
    nodes = {}
    i = 0
    for line in lines:
        line = line.strip()
        if line.startswith("M:"):
            b_line = line.split()
            slots_line = lines[i+1].strip()
            s_line = slots_line.split()
            nodes[b_line[1]] = {"role":"master", "id":b_line[1], "socket":b_line[2], "slots":s_line[0][6:], "num":s_line[1][1:]}
        elif line.startswith("S:") or line.startswith("FS"):
            b_line = line.split()
            slots_line = lines[i+1].strip()
            s_line = slots_line.split()
            replicates_line = lines[i+2].strip()
            r_line = replicates_line.split()
            nodes[b_line[1]] = {"role":"slave", "id":b_line[1], "socket":b_line[2], "slots":s_line[0][6:], "num":s_line[1][1:], "replicates":r_line[1]}
        i = i + 1

    return nodes

def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])

def delete_nodes_from_cluster(nodes, local_ip):
    '''
    @param nodes the list of server ids of nodes to be deleted in the format
				 ["a7796c2a45c736624a7666ce21cab9ff963c5a1e",
                  "3a9f443600daedc2828b7854653616e5dc4dc625"]
    '''
    for node in nodes: # nodes is the list of server id
        ret = subprocess.call(["/opt/redis/bin/redis-trib.rb del-node %s:6379 %s" % (local_ip, node)], shell=True)
        if ret != 0:
            print "Delete node [%s] from the cluster failed" % node
            return ret
    return 0

def delete_nodes(nodes):
    '''
    @params nodes the list IPs of nodes to be deleted in the format
                  [ip1,ip2,...]
    '''
    local_ip = get_ip_address('eth0')
    if not local_ip:
        return -1
    
    cluster_info = get_redis_cluster_info(local_ip)
    
	# Organize the cluster info into shard list,
    # and save map with the pair <ip, server id>
    ips_serverIDs = {}
    shards = {}
    for server_id, info in cluster_info.items():
    	socket = info["socket"]
        ip = socket.split(":")[0]
        ips_serverIDs[ip] = server_id
        
        role = info["role"]
        if role == "master":
            master_ip = ip
        else:
            master_ip = cluster_info[info["replicates"]]["socket"].split(":")[0]

        if master_ip not in shards.keys():
            shards[master_ip] = []
        shards[master_ip].append(ip)        
 
    # Categorize nodes into the ones that are deleted directly, the other ones which
    # are the only one left in its shard, which means it needs resharding.
    no_shard_ips = []
    shard_ips = []
    total_shard_num = len(shards.keys())
    for ip in nodes: # nodes to be deleted
        found = False
        for shard in shards.values():
            if not shard:
                continue
            if ip in shard:
	        if len(shard) == 1:
	            shard_ips.append(ip)
	        else:
	            no_shard_ips.append(ip)
	        shard.remove(ip)
		found = True
        if not found:
            print "The node [%s] that is to delete is not in the cluster, exit with failure" % ip
            exit(1)
 
    if shard_ips: # reshard first, then delete
        # Caculate slots per shard
        deleted_shard_num = len(shard_ips)
        existing_shard_num = total_shard_num - deleted_shard_num
		
        # Get left shard server IDs
        existing_shard_server_ids = []
        for ip, shard in shards.items():
            if shard:
                existing_shard_server_ids.append(ips_serverIDs[ip])

        deleted_shard_server_ids = []
        for ip in shard_ips:
            deleted_shard_server_ids.append(ips_serverIDs[ip])

        # Resharding
        for server_id in deleted_shard_server_ids:
            node_info = cluster_info[server_id]
            slots_num = long(node_info["num"])
            slots_per_shard = slots_num / existing_shard_num
            mod_slots = slots_num % existing_shard_num
	        
            for target in existing_shard_server_ids:
                num = slots_per_shard + mod_slots
                if num <= 0:
                    break
                cmd = "/opt/redis/bin/redis-trib.rb reshard --from %s --to %s --slots %s --yes %s:6379 > /data/redis/redis.log 1>&2" % \
	                (server_id, target, num, local_ip) 	        
                ret = subprocess.call([cmd], shell=True)
                if ret != 0:
	                print "Reshard the redis cluster failed"
	                exit(1) 
                mod_slots = 0 # This variable is only used once
	            
        print "Reshard the redis cluster successful"

        # delete the nodes now
        ret = delete_nodes_from_cluster(deleted_shard_server_ids, local_ip)
        if ret != 0:
            print "Delete nodes from the redis cluster failed"
            exit(1) 

    if no_shard_ips: # delete the nodes directly
        server_ids = []
        for ip in no_shard_ips:
            server_ids.append(ips_serverIDs[ip])
        ret = delete_nodes_from_cluster(server_ids, local_ip)
        if ret != 0:
            print "Delete nodes from the redis cluster failed"
            exit(1) 

    print "Delete nodes [%s] from the redis cluster successful" % nodes

    return 0

def main():
    # Load new nodes from the file /opt/redis/scale-in.info which is in format as below
    # 192.168.100.10
    # 192.168.100.20
    filehandler = open('/opt/redis/scaling-in.info', 'r')
    if not filehandler:
        print "Cannot open the file"
        exit(1)

    nodes = []
    filehandler.seek(0)
    lines = filehandler.readlines()
    for line in lines:
        if not line or not line.strip():
            continue
        nodes.append(line.strip())
    
    ret = 0
    if nodes:
        ret = delete_nodes(nodes)
        if ret != 0:
            print "Delete nodes [%s] failed" % nodes
            exit(1)
        else:
            print "Delete nodes [%s] successful" % nodes
            exit(0)
    
if __name__ == '__main__':
    main()
