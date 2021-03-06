#!/bin/bash

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

echo "start"
CNIPFILE="./china_ip_list.txt"
for A in `cat $CNIPFILE`; do
	IPR=${A%/*} # 192.168.2.0 
	CDR=${A#*/} # 24
	MSK=$(cdr2mask $CDR)
	#route 10.8.0.0 255.255.0.0 vpn_gateway
	#route 40.83.93.39 255.255.255.255 net_gateway
	echo "route $IPR $MSK net_gateway"
	echo "route $IPR $MSK net_gateway" >> "./china_ip_list.openvpn.txt"
done
echo "end"
