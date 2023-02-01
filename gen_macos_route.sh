#!/bin/bash
# ip -6 r get default (netstat -nr | grep default)
# route add -inet6 2606:4700:4700::/48 fe80::9a00:74ff:feab:b353%en0
# mtr 2606:4700:4700::1111
# /sbin/route delete -inet6 2606:4700:4700::/48
output="./cn.mac.up.sh"
rm $output
# Use openvpn script provides env var
GW="\$route_net_gateway"
# GW6="\$net_gateway_ipv6"
CNIPFILE="./china_cidr4.txt"
CN6IPFILE="./china_cidr6.txt"

cat > $output << EOF
#!/usr/bin/env zsh
echo "GET IPV6 GW: "
echo "ip -6 r get default"
echo "    or"
echo "netstat -nr | grep default"
# route_net_gateway="192.168.2.1"
# net_gateway_ipv6="fe80::9a00:74ff:feab:b353"

echo "===>>>> route_net_gateway=\$route_net_gateway"
echo "===>>>> net_gateway_ipv6=\$net_gateway_ipv6"
echo "===>>>> /sbin/route -n add -net 150.230.40.135/32 $GW"
# echo "===>>>> /sbin/route -n add -inet6 2603:c024:c004:5900::/64 $GW6"
# mars
/sbin/route -n add -net 150.230.40.135/32 $GW
# /sbin/route -n add -inet6 2603:c024:c004:5900::/64 $GW6
# ac
/sbin/route -n add -net 192.9.138.146/32 $GW
# venus
/sbin/route -n add -net 155.248.177.72/32 $GW
# /sbin/route -n add -inet6 2603:c021:800c:c9ee::/64 $GW6
# sun
/sbin/route -n add -net 150.158.164.110/32 $GW
/sbin/route -P ADD 150.158.164.110 MASK 255.255.255.255 $GW
#####
EOF
for A in `cat $CNIPFILE`; do
   echo "/sbin/route -n add -net $A $GW"
	echo "/sbin/route -n add -net $A $GW" >> $output
done
# for A in `cat $CN6IPFILE`; do
#    echo "/sbin/route -n add -inet6 $A $GW6"
# 	echo "/sbin/route -n add -inet6 $A $GW6" >> $output
# done

output="./cn.mac.down.sh"

rm $output
cat > $output << EOF
#!/usr/bin/env zsh
/sbin/route -n delete 150.230.40.135/32
# /sbin/route -n delete 2603:c024:c004:5900::/64
/sbin/route -n delete 192.9.138.146/32
/sbin/route -n delete 155.248.177.72/32
# /sbin/route -n delete 2603:c021:800c:c9ee::/64
/sbin/route -n delete 150.158.164.110/32 
EOF
for A in `cat $CNIPFILE`; do
   echo "/sbin/route -n delete $A"
	echo "/sbin/route -n delete $A" >> $output
done
# for A in `cat $CN6IPFILE`; do
#    echo "/sbin/route -n delete -inet6 $A"
# 	echo "/sbin/route -n delete -inet6 $A" >> $output
# done
echo "end"

