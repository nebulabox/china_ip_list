#!/bin/bash
output="./cn.lin.up.sh"
rm $output
GW="\$1"
GW6="\$2"
CNIPFILE="./china_cidr4.txt"
CN6IPFILE="./china_cidr6.txt"

cat > $output << EOF
#!/usr/bin/env zsh
# some special ips
# mars
sudo ip route add 150.230.40.135/32 via $GW
sudo ip route add 2603:c024:c004:5900::/64 via $GW6
# ac
sudo ip route add 192.9.138.146/32 via $GW
# venus
sudo ip route add 155.248.177.72/32 via $GW
sudo ip route add 2603:c021:800c:c9ee::/64 via $GW6
# sun
sudo ip route add 150.158.164.110/32 via $GW
#####
EOF
for A in `cat $CNIPFILE`; do
   echo "sudo ip route add $A via $GW"
   echo "sudo ip route add $A via $GW" >> $output
done
for A in `cat $CN6IPFILE`; do
   echo "sudo ip route add $A via $GW6"
   echo "sudo ip route add $A via $GW6" >> $output
done

output="./cn.lin.down.sh"

rm $output
cat > $output << EOF
#!/usr/bin/env zsh
sudo ip route delete 2603:c024:c004:5900::/64
sudo ip route delete 2603:c021:800c:c9ee::/64
sudo ip route delete 192.9.138.146/32
sudo ip route delete 150.230.40.135/32
sudo ip route delete 155.248.177.72/32
sudo ip route delete 150.158.164.110/32 
EOF
for A in `cat $CNIPFILE`; do
   echo "sudo ip route delete $A"
	echo "sudo ip route delete $A" >> $output
done
for A in `cat $CN6IPFILE`; do
   echo "sudo ip route delete $A"
	echo "sudo ip route delete $A" >> $output
done
echo "end"

