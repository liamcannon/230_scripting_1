#!/bin/bash

#system info page - A script to produce an HTML file containing system information

if [[ "$EUID" !=  0 ]]; then
	echo "Must Run as Root"
	exit
fi

TITLE="System Information for $HOSTNAME"
RIGHT_NOW="$(date +"%x %r %Z")"
TIME_STAMP="Updated on $RIGHT_NOW by $USER"

system_info() {
	uname -a
}
free_memory() {
	free -h
}
disk_information() {
	lsblk
}
groups_assigned() {
	groups
}
ip_address() {
	ifconfig | grep inet" " | awk '{print $2}'
}
see_permission() {
	stat sysinfo_page.sh | grep "Access: (" | awk '{print $2}'
}
system_specs() {
	lscpu | grep "Model name"
}

cat > sysinfo_page.html << _EOF_
<!DOCTYPE html>
<html>
<head>
	<title>$TITLE</title>
</head>
<body>
	<h1>$TITLE></h1>
	<p>$TIME_STAMP</p>
	<p>$RIGHT_NOW</p>
	<p>$(system_info)</p>
	<p>$(free_memory)</p>
	<p>$(disk_information)</p>
	<p>$(groups_assigned)</p>
	<p>$(ip_address)</p>
	<p>$(see_permission)</p>
	<p>$(system_specs)</p>

</body>
</html>
_EOF_

