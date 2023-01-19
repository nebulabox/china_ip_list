#!/bin/bash
output="./cn.lin.up.sh"
rm $output
GW="192.168.2.1"
CNIPFILE="./china_ip_list.txt"

cat > $output << EOF
#!/usr/bin/env zsh
# some special ips
sudo ip route add 150.230.40.135/32 via $GW
sudo ip route add 155.248.177.72/32 via $GW
sudo ip route add 150.158.164.110/32 via $GW
sudo ip route add 192.168.0.0/16 via $GW
#####
EOF
for A in `cat $CNIPFILE`; do
   echo "sudo ip route add $A via $GW"
   echo "sudo ip route add $A via $GW" >> $output
done

output="./cn.lin.down.sh"

rm $output
cat > $output << EOF
#!/usr/bin/env zsh
sudo ip route delete 150.230.40.135/32
sudo ip route delete 155.248.177.72/32
sudo ip route delete 150.158.164.110/32 
sudo ip route delete 192.168.0.0/16
EOF
for A in `cat $CNIPFILE`; do
   echo "sudo ip route delete $A"
	echo "sudo ip route delete $A" >> $output
done
echo "end"
