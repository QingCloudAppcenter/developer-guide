# logrotate.ps1
# This PowerShell script replicates the functionality of the logrotate utility on Linux/Unix-based systems

# Parameters
# -Path 		A valid absolute path to a log folder
# -Include		A log file to rotate or a wildcard pattern for including files
# -FileSize		Maximum file size for each log file
# -Rotate		The number of log files to keep

# Get command line parameters
Param (
	[string]$Path = 'C:\Program Files (x86)\QingCloud\App Agent\log',
	[string]$Include = '*.log',
    [int64]$FileSize = 1kb,
	[int]$Rotate = 10
)

# Remove any trailing slashes from the path
$Path = $Path.TrimEnd('\');

# Make sure the path exists
if ((Test-Path -Path $Path -PathType container) -ne $True) {
	Write-Host "The log folder path specified does not exist."
}
else {
	Write-Host "Rotating logs in $($Path)..."
	$count = 0

	# Find matching log files in the specified path 
	$MatchingFiles = Get-ChildItem "$($Path)\*" -Include:$Include

	foreach ($f in $MatchingFiles) {
		# Make sure the file exists
		if (($f.FullName) -and (Test-Path $f.FullName) -and ($f.length -ige $FileSize)) {
			
			# Delete old log files
			if (Test-Path "$($f.FullName).$Rotate") {
				Remove-Item "$($f.FullName).$Rotate" -Force
			}

			# Rotate the newer log files
			for ($i = $Rotate; $i -ge 1; $i--) {
				if ($i -eq 1) {
					Rename-Item -Path $f.FullName -NewName "$($f.Name).$i"
				}
				else {
					if (Test-Path "$($f.FullName).$($i-1)") {
						Rename-Item -Path "$($f.FullName).$($i-1)" -NewName "$($f.Name).$i"
					}
				}
			}

			$count++
		}
	}
	Write-Host "$count log file(s) were rotated in the specified directory."
}