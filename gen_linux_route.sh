#!/usr/bin/env zsh
# sudo ip -6 r get default
# sudo ip -6 route add 2606:4700:4700::/48 via fe80::aa5e:45ff:fe99:b6c0 dev ens32
# sudo mtr 2606:4700:4700::1111
# sudo ip -6 r delete 2606:4700:4700::/48
output="./cn.lin.up.sh"
rm $output
GW="\$route_net_gateway"
# GW6="\$net_gateway_ipv6"
CNIPFILE="./china_cidr4.txt"
# CN6IPFILE="./china_cidr6.txt"

cat > $output << EOF
#!/usr/bin/env zsh
# route_net_gateway="192.168.2.1"
# net_gateway_ipv6="fe80::9a00:74ff:feab:b353"
# some special ips
# mars
sudo ip route add 150.230.40.135/32 via $GW 
# ac
sudo ip route add 192.9.138.146/32 via $GW 
# venus
sudo ip route add 155.248.177.72/32 via $GW 
# sun
sudo ip route add 150.158.164.110/32 via $GW 
#####
EOF
for A in `cat $CNIPFILE`; do
   echo "sudo ip route add $A via $GW "
   echo "sudo ip route add $A via $GW " >> $output
done

output="./cn.lin.down.sh"
rm $output
cat > $output << EOF
#!/usr/bin/env zsh
sudo ip route delete 192.9.138.146/32
sudo ip route delete 150.230.40.135/32
sudo ip route delete 155.248.177.72/32
sudo ip route delete 150.158.164.110/32 
EOF
for A in `cat $CNIPFILE`; do
   echo "sudo ip route delete $A"
	echo "sudo ip route delete $A" >> $output
done

echo "end"

