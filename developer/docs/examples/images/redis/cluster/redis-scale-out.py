import subprocess
import socket
import fcntl
import struct
import time

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

def add_nodes_to_cluster(nodes, local_ip):
    for node in nodes:
        ret = subprocess.call(["/opt/redis/bin/redis-trib.rb add-node %s:6379 %s:6379" % (node, local_ip)], shell=True)
        if ret != 0:
            print "Add node [%s] to the cluster failed" % node
            return ret
    
    return 0

def add_masters(masters):
    ip = get_ip_address('eth0')
    if not ip:
        return -1
    ret = add_nodes_to_cluster(masters, ip)
    if ret != 0:
        return -1
    
    time.sleep(5)
    
    cluster_info = get_redis_cluster_info(ip)
    
    # Caculate slots per shard
    allocated_master_server_ids = []
    unallocated_master_server_ids = []
    unallocated_master_private_ips = []
    for server_id, info in cluster_info.items():
        role = info["role"]
        if role == "master":
            num = info["num"]
            if num == 0 or num == "0":
                unallocated_master_server_ids.append(server_id)
                ip = info["socket"][:-(len("6379")+1)]
                unallocated_master_private_ips.append(ip)
            else:
                allocated_master_server_ids.append(server_id)        
    source = ",".join(allocated_master_server_ids)
    slots_per_master = 16384 / (len(allocated_master_server_ids)+len(unallocated_master_server_ids))

    # Reshard
    max_tries = 3
    for target in unallocated_master_server_ids: 
        tries = 0
        while tries < max_tries:           
            cmd = "/opt/redis/bin/redis-trib.rb reshard --from %s --to %s --slots %s --yes %s:6379 > /data/redis/redis.log 1>&2" % \
                (source, target, slots_per_master, ip) 
            ret = subprocess.call([cmd], shell=True)
            if ret != 0:
                tries = tries + 1
            else:
                break
        if ret != 0:
            print "Reshard the redis cluster failed: %s" % ret
            return -1 

    return 0

def add_slaves(slaves):
    return 0

def main():
    # Load new nodes from the file /opt/redis/scale-out.info which is in format as below
    # master 192.168.100.10
    # master 192.168.100.20
    # The role may be slave which depends on the role name of the replicas
    filehandler = open('/opt/redis/scaling-out.info', 'r')
    if not filehandler:
        print "Cannot open the file"
        exit(1)

    masters = []
    slaves = []
    filehandler.seek(0)
    lines = filehandler.readlines()
    for line in lines:
        if not line or not line.strip():
            continue
        node = line.split()
        role = node[0].strip()
        if role == "master":
            masters.append(node[1].strip())
        else:
            slaves.append(node[1].strip())
  
    ret = 0
    if masters:
        ret = add_masters(masters)
   
    if slaves:
        ret = add_slaves(slaves)

    if ret != 0:
        print "Add new nodes failed"
        exit(1)
    else:
       print "Add new nodes successful"
       exit(0)
    
if __name__ == '__main__':
    main()
