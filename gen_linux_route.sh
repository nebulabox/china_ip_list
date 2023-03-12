#!/usr/bin/env zsh
# ip -6 r get default
# ip -6 route add 2606:4700:4700::/48 via fe80::aa5e:45ff:fe99:b6c0 dev ens32
# mtr 2606:4700:4700::1111
# ip -6 r delete 2606:4700:4700::/48
# OpenVPN ->: route_net_gateway="192.168.2.1"
# OpenVPN ->: net_gateway_ipv6="fe80::9a00:74ff:feab:b353"
output="./cn.lin.up.sh"
rm $output
GW="\$route_net_gateway"
# GW6="\$net_gateway_ipv6"
CNIPFILE="./china_cidr4.txt"
TUNDEV="\$1" # tun11
# CN6IPFILE="./china_cidr6.txt"

cat > $output << EOF
#!/bin/sh
# default route
# ip route add default via $TUNDEV
# mars
ip route add 150.230.40.135/32 via $GW 
# ac
ip route add 192.9.138.146/32 via $GW 
# venus
ip route add 155.248.177.72/32 via $GW 
# sun
ip route add 150.158.164.110/32 via $GW 
#####
EOF
for A in `cat $CNIPFILE`; do
   echo "ip route add $A via $GW "
   echo "ip route add $A via $GW " >> $output
done

output="./cn.lin.down.sh"
rm $output
cat > $output << EOF
#!/bin/sh
ip route delete default
ip route add default via $GW
ip route delete 192.9.138.146/32
ip route delete 150.230.40.135/32
ip route delete 155.248.177.72/32
ip route delete 150.158.164.110/32 
EOF
for A in `cat $CNIPFILE`; do
   echo "ip route delete $A"
	echo "ip route delete $A" >> $output
done

echo "end"

