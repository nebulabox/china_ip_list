#!/bin/bash
output="./cn.win.up.ps1"
rm $output
GW="192.168.9.1"
IFC="192.168.9.70"
CNIPFILE="./china_ip_list.txt"

mask2cdr ()
{
   # mask2cdr 255.255.0.0
   # Assumes there's no "255." after a non-255 byte in the mask
   local x=${1##*255.}
   set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) ${x%%.*}
   x=${1%%$3*}
   echo $(( $2 + (${#x}/4) ))
}
cdr2mask ()
{
   # cdr2mask 16
   # Number of args to shift, 255..255, first non-255 byte, zeroes
   set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
   [ $1 -gt 1 ] && shift $1 || shift
   echo ${1-0}.${2-0}.${3-0}.${4-0}
}

cat > $output << EOF
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}
route -P ADD 150.230.40.135 MASK 255.255.255.255 $GW METRIC 2 IF $IFC
route -P ADD 155.248.177.72   MASK 255.255.255.255 $GW METRIC 2 IF $IFC
route -P ADD 150.158.164.110   MASK 255.255.255.255 $GW METRIC 2 IF $IFC
EOF
for A in `cat $CNIPFILE`; do
	IPR=${A%/*} # 192.168.2.0 
	CDR=${A#*/} # 24
	MSK=$(cdr2mask $CDR)
   # route ADD destination_network MASK subnet_mask gateway_ip metric_cost
   # route -p 持久保存路由。
   # route -P ADD 192.168.35.0 MASK 255.255.255.0 192.168.0.2
	echo "route -P ADD $IPR MASK $MSK $GW METRIC 2 IF $IFC"
	echo "route -P ADD $IPR MASK $MSK $GW METRIC 2 IF $IFC" >> $output
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
	IPR=${A%/*} # 192.168.2.0 
	CDR=${A#*/} # 24
	MSK=$(cdr2mask $CDR)
   # route delete destination_network
   # route delete 192.168.35.0
	echo "route delete $IPR"
	echo "route delete $IPR" >> $output
done


echo "end"
