#!/bin/bash
output="./cn.mac.up.sh"
rm $output
GW="192.168.2.1"
CNIPFILE="./china_ip_list.txt"

cat > $output << EOF
#!/usr/bin/env zsh
# default gateway 
sudo route delete default
sudo route add default 10.10.6.1
# some special ips
sudo route -n add -net 150.230.40.135/32 $GW
sudo route -n add -net 155.248.177.72/32 $GW
sudo route -n add -net 150.158.164.110/32 $GW
sudo route -n add -net 192.168.0.0/16 $GW
#####
EOF
for A in `cat $CNIPFILE`; do
   echo "sudo route -n add -net $A $GW"
	echo "sudo route -n add -net $A $GW" >> $output
done

output="./cn.mac.down.sh"

rm $output
cat > $output << EOF
#!/usr/bin/env zsh
sudo route delete default
sudo route add default $GW
sudo route -n delete 150.230.40.135/32
sudo route -n delete 155.248.177.72/32
sudo route -n delete 150.158.164.110/32 
sudo route -n delete 192.168.0.0/16
EOF
for A in `cat $CNIPFILE`; do
   echo "sudo route -n delete $A"
	echo "sudo route -n delete $A" >> $output
done
echo "end"
