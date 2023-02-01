#!/bin/bash
# sudo ip -6 r get default
# sudo ip -6 route add 2606:4700:4700::/48 via fe80::aa5e:45ff:fe99:b6c0 dev ens32
# sudo mtr 2606:4700:4700::1111
# sudo ip -6 r delete 2606:4700:4700::/48
output="./cn.lin.up.sh"
rm $output
GW="\$1"
GW6="\$2"
DEV="\$3"
CNIPFILE="./china_cidr4.txt"
CN6IPFILE="./china_cidr6.txt"

cat > $output << EOF
#!/usr/bin/env zsh
if [ "\$#" -le 3 ]; then
    echo "GET the ipv6gw and devname with: "
    echo "     sudo ip -6 r get default "
    echo "gen_linux_route.sh ipv4gw ipv6gw devname"
    exit 1
fi
# some special ips
# mars
sudo ip route add 150.230.40.135/32 via $GW dev $DEV
sudo ip route add 2603:c024:c004:5900::/64 via $GW6 dev $DEV
# ac
sudo ip route add 192.9.138.146/32 via $GW dev $DEV
# venus
sudo ip route add 155.248.177.72/32 via $GW dev $DEV
sudo ip route add 2603:c021:800c:c9ee::/64 via $GW6 dev $DEV
# sun
sudo ip route add 150.158.164.110/32 via $GW dev $DEV
#####
EOF
for A in `cat $CNIPFILE`; do
   echo "sudo ip route add $A via $GW dev $DEV"
   echo "sudo ip route add $A via $GW dev $DEV" >> $output
done
for A in `cat $CN6IPFILE`; do
   echo "sudo ip route add $A via $GW6 dev $DEV"
   echo "sudo ip route add $A via $GW6 dev $DEV" >> $output
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

