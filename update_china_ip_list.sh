#/bin/bash
rm china_ip_list.txt
wget https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt

rm china_cidr4.txt
wget https://raw.githubusercontent.com/ChanthMiao/China-IPv4-List/release/cn.txt -O china_cidr4.txt

rm china_cidr6.txt
wget https://raw.githubusercontent.com/ChanthMiao/China-IPv6-List/release/cn6.txt -O china_cidr6.txt
