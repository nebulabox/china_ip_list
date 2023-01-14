#!/bin/zsh
echo "ipset -quiet create chnroute hash:net maxelem 65536" > chnroute.sh; 
chmod +x chnroute.sh; 
for i in `cat china_ip_list.txt`; do 
	echo "ipset -quiet add chnroute "$i >>chnroute.sh; 
done
