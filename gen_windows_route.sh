#!/bin/bash
output="./cn.win.up.ps1"
rm $output
GW="192.168.9.1"
GW6="fe80::aa5e:45ff:fe99:b6c0"
CNIPFILE="./china_cidr4.txt"
CN6IPFILE="./china_cidr6.txt"

cat > $output << EOF
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}
# mars
route -P ADD 150.230.40.135 MASK 255.255.255.255 $GW
route -P ADD 2603:c024:c004:5900::/64 $GW6
# ac
route -P ADD 192.9.138.146 MASK 255.255.255.255 $GW
# venus
route -P ADD 155.248.177.72 MASK 255.255.255.255 $GW
route -P ADD 2603:c021:800c:c9ee::/64 $GW6
# sun
route -P ADD 150.158.164.110 MASK 255.255.255.255 $GW
EOF
for A in `cat $CNIPFILE`; do
   # route -p 持久保存路由。
   # route -P ADD 1.1.8.0/24 192.168.0.2
	echo "route -P ADD $A $GW"
	echo "route -P ADD $A $GW" >> $output
done
for A in `cat $CN6IPFILE`; do
	echo "route -P ADD $A $GW6"
	echo "route -P ADD $A $GW6" >> $output
done

output="./cn.win.down.ps1"
rm $output
cat > $output << 'EOF'
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}
EOF
for A in `cat $CNIPFILE`; do
	echo "route delete $A"
	echo "route delete $A" >> $output
done

for A in `cat $CN6IPFILE`; do
	echo "route delete $A"
	echo "route delete $A" >> $output
done

echo "end"
