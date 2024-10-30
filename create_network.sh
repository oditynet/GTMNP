#!/bin/bash
## Version 0.1 by oditynet 


## [!!!] EDIT line 328,331,334,337  - create 1 or 2 interface
## [!!!] EDIT MODE: 1,2,3,4 ^? 
MODE=4 #1=eth,2=vlan1,3=bond,4=bond+vlan1

eth1="eth0"
eth2="eth1"
vlan1="1010"
vlan2="1020"
bond1="bond0"  #IP from $ip1
bond2="bond1"   #IP from $ip2
t=$(date '+%T')
#path="/tmp/ifaces.$t"
path="/etc/net"

ip1=$1  #10.6.16.5
ip2=$2  #10.7.16.5
route1=$3  #10.6.1.1
route2=$4  #10.7.1.1
prefix1=24
prefix2=22

#----------------------------------------------------------------------------

function network_only {
echo "[!] Mode=1"
#checking
if [[ -z $eth1 ]]; then echo "Param eth1=NULL"; exit 0;fi
if [[ $1 == '2' && -z $eth2 ]]; then echo "Param eth2=NULL"&& exit 0;fi
if [[ -z $ip1 ]]; then echo "Param ip1=NULL"&& exit 0;fi
if [[ $1 == '2' && -z $ip2 ]]; then echo "Param ip2=NULL"&& exit 0;fi
if [[ -z $route1 ]]; then echo "Param route1=NULL"&& exit 0;fi
if [[ $1 == '2' && -z $route2 ]]; then echo "Param route2=NULL"&& exit 0;fi
#GO

echo "Create ethernet 1"
mkdir $path/ifaces/$eth1
echo "$ip1/$prefix1" > $path/ifaces/$eth1/ipv4address
echo "default via $route1" > $path/ifaces/$eth1/ipv4route
tee $path/ifaces/$eth1/options 1>/dev/null << EOF
TYPE=eth
CONFIG_WIRELESS=no
CONFIG_IPV4=no
DISABLED=no
NM_CONTROLLED=no
ONBOOT=yes
CONFIG_IPV6=no
EOF

[ $1 == '1' ] && exit 1

echo "Create ethernet 2"
mkdir $path/ifaces/$eth2
echo "$ip2/$prefix2" > $path/ifaces/$eth2/ipv4address
echo "default via $route2" > $path/ifaces/$eth2/ipv4route
 tee $path/ifaces/$eth2/options 1>/dev/null << EOF
TYPE=eth
CONFIG_WIRELESS=no
CONFIG_IPV4=no
DISABLED=no
NM_CONTROLLED=no
ONBOOT=yes
CONFIG_IPV6=no
EOF
exit 0
}

#----------------------------------------------------------------------------

function network_vlan {
echo "[!] Mode=2"
 #checking
if [[ -z $eth1 ]]; then echo "Param eth1=NULL"; exit 0;fi
if [[ $1 == '2' && -z $eth2 ]]; then echo "Param eth2=NULL"&& exit 0;fi
if [[ -z $ip1 ]]; then echo "Param ip1=NULL"&& exit 0;fi
if [[ $1 == '2' && -z $ip2 ]]; then echo "Param ip2=NULL"&& exit 0;fi
if [[ -z $route1 ]]; then echo "Param route1=NULL"&& exit 0;fi
if [[ $1 == '2' && -z $route2 ]]; then echo "Param route2=NULL"&& exit 0;fi
if [[ -z $vlan1 ]]; then echo "Param vlan1=NULL"&& exit 0;fi
if [[ $1 == '2' && -z $vlan2 ]]; then echo "Param vlan2=NULL"&& exit 0;fi

#GO
        
echo "Create Vlan1"
mkdir $path/ifaces/$eth1
mkdir $path/ifaces/$eth1.$vlan1

echo "$ip1/$prefix1" > $path/ifaces/$eth1.$vlan1/ipv4address
echo "default via $route1" > $path/ifaces/$eth1.$vlan1/ipv4route
 tee $path/ifaces/$eth1.$vlan1/options 1>/dev/null << EOF
TYPE=vlan
HOST=$eth1
VID=$vlan1
BOOTPROTO=static
ONBOOT=yes
EOF
[ -z $vlan1 ] ||  tee $path/ifaces/$eth1/options 1>/dev/null << EOF
TYPE=eth
CONFIG_WIRELESS=no
CONFIG_IPV4=no
DISABLED=no
NM_CONTROLLED=no
ONBOOT=yes
CONFIG_IPV6=no
EOF

[ $1 == '1' ] && exit 1 

echo "Create Vlan2"
mkdir $path/ifaces/$eth2
mkdir $path/ifaces/$eth2.$vlan2

echo "$ip2/$prefix2" > $path/ifaces/$eth2.$vlan2/ipv4address
echo "default via $route2" > $path/ifaces/$eth2.$vlan2/ipv4route
 tee $path/ifaces/$eth2.$vlan2/options 1>/dev/null << EOF
TYPE=vlan
HOST=$eth2
VID=$vlan2
BOOTPROTO=static
ONBOOT=yes
EOF
 tee $path/ifaces/$eth2/options 1>/dev/null << EOF
TYPE=eth
CONFIG_WIRELESS=no
CONFIG_IPV4=no
DISABLED=no
NM_CONTROLLED=no
ONBOOT=yes
CONFIG_IPV6=no
EOF

exit 0

}
#----------------------------------------------------------------------------

network_bond(){
echo "[!] Mode=3"
 #checking
if [[ -z $eth1 ]]; then echo "Param eth1=NULL"; exit 0;fi
if [[ $1 == '2' && -z $eth2 ]]; then echo "Param eth2=NULL"&& exit 0;fi
if [[ -z $ip1 ]]; then echo "Param ip1=NULL"&& exit 0;fi
if [[ $1 == '2' && -z $ip2 ]]; then echo "Param ip2=NULL"&& exit 0;fi
if [[ -z $route1 ]]; then echo "Param route1=NULL"&& exit 0;fi
if [[ $1 == '2' && -z $route2 ]]; then echo "Param route2=NULL"&& exit 0;fi
if [[ -z $bond1 ]]; then echo "Param bond1=NULL"&& exit 0;fi
if [[ $1 == '2' && -z $bond2 ]]; then echo "Param bond2=NULL"&& exit 0;fi

#GO
 
echo "Create Bond1"
mkdir $path/ifaces/$eth1
mkdir $path/ifaces/$eth2
mkdir $path/ifaces/$bond1
echo "$ip1/$prefix1" > $path/ifaces/$bond1/ipv4address
echo "default via $route1" > $path/ifaces/$bond1/ipv4route
 tee $path/ifaces/$eth1/options 1>/dev/null << EOF
TYPE=eth
CONFIG_WIRELESS=no
CONFIG_IPV4=no
DISABLED=no
NM_CONTROLLED=no
ONBOOT=yes
CONFIG_IPV6=no
EOF
 tee $path/ifaces/$eth2/options 1>/dev/null << EOF
TYPE=eth
CONFIG_WIRELESS=no
CONFIG_IPV4=no
DISABLED=no
NM_CONTROLLED=no
ONBOOT=yes
CONFIG_IPV6=no
EOF
 tee $path/ifaces/$bond1/options 1>/dev/null << EOF
TYPE=bond
ONBOOT=yes
DISABLED=no
NM_CONTROLLED=no
CONFIG_WIRELESS=no
CONFIG_IPV4=yes
CONFIG_IPV6=no
BOOTPROTO=static
HOST="$eth1 $eth2"
BONDMODE=4
BONDOPTIONS="miimon=1 lacp_rate=fast downdelay=0"
EOF

 
[ $1 == '1' ] && exit 1

echo "Create Bond2"
mkdir $path/ifaces/$bond2
echo "$ip2/$prefix2" > $path/ifaces/$bond2/ipv4address
echo "default via $route2" > $path/ifaces/$bond2/ipv4route
 tee $path/ifaces/$bond2/options 1>/dev/null << EOF
TYPE=bond
ONBOOT=yes
DISABLED=no
NM_CONTROLLED=no
CONFIG_WIRELESS=no
CONFIG_IPV4=yes
CONFIG_IPV6=no
BOOTPROTO=static
HOST="$eth1 $eth2"
BONDMODE=4
BONDOPTIONS="miimon=1 lacp_rate=fast downdelay=0"
EOF

exit 0
}

#----------------------------------------------------------------------------

network_bond_vlan(){
echo "[!] Mode=4"

 #checking
if [[ -z $eth1 ]]; then echo "Param eth1=NULL"; exit 0;fi
if [[ $1 == '2' && -z $eth2 ]]; then echo "Param eth2=NULL"&& exit 0;fi
if [[ -z $ip1 ]]; then echo "Param ip1=NULL"&& exit 0;fi
if [[ $1 == '2' && -z $ip2 ]]; then echo "Param ip2=NULL"&& exit 0;fi
if [[ -z $route1 ]]; then echo "Param route1=NULL"&& exit 0;fi
if [[ $1 == '2' && -z $route2 ]]; then echo "Param route2=NULL"&& exit 0;fi
if [[ -z $vlan1 ]]; then echo "Param vlan1=NULL"&& exit 0;fi
if [[ $1 == '2' && -z $vlan2 ]]; then echo "Param vlan2=NULL"&& exit 0;fi
if [[ -z $bond1 ]]; then echo "Param bond1=NULL"&& exit 0;fi
if [[ $1 == '2' && -z $bond2 ]]; then echo "Param bond2=NULL"&& exit 0;fi

#GO
 
echo "Create Bond1.vlan1"
mkdir $path/ifaces/$eth1
mkdir $path/ifaces/$eth2
mkdir $path/ifaces/$bond1
mkdir $path/ifaces/$bond1.$vlan1

echo "$ip1/$prefix1" > $path/ifaces/$bond1.$vlan1/ipv4address
echo "default via $route1" > $path/ifaces/$bond1.$vlan1/ipv4route
 tee $path/ifaces/$bond1.$vlan1/options 1>/dev/null << EOF
TYPE=vlan
HOST=$bond1
VID=$vlan1
BOOTPROTO=static
ONBOOT=yes
EOF
 tee $path/ifaces/$eth1/options 1>/dev/null << EOF
TYPE=eth
CONFIG_WIRELESS=no
CONFIG_IPV4=no
DISABLED=no
NM_CONTROLLED=no
ONBOOT=yes
CONFIG_IPV6=no
EOF

 tee $path/ifaces/$eth2/options 1>/dev/null << EOF
TYPE=eth
CONFIG_WIRELESS=no
CONFIG_IPV4=no
DISABLED=no
NM_CONTROLLED=no
ONBOOT=yes
CONFIG_IPV6=no
EOF

 tee $path/ifaces/$bond1/iplink 1>/dev/null << EOF
mtu 9000
EOF
 tee $path/ifaces/$bond1/options 1>/dev/null << EOF
TYPE=bond
ONBOOT=yes
DISABLED=no
NM_CONTROLLED=no
CONFIG_WIRELESS=no
CONFIG_IPV4=yes
CONFIG_IPV6=no
BOOTPROTO=static
HOST="$eth1 $eth2"
BONDMODE=4
BONDOPTIONS="miimon=1 lacp_rate=fast downdelay=0"
EOF

[ $1 == '1' ] && exit 1

echo "Create Bond2.vlan2"
mkdir $path/ifaces/$bond2 2>/dev/null
mkdir $path/ifaces/$bond2.$vlan2

echo "$ip2/$prefix2" > $path/ifaces/$bond2.$vlan2/ipv4address
echo "default via $route2" > $path/ifaces/$bond2.$vlan2/ipv4route
 tee $path/ifaces/$bond2.$vlan2/options 1>/dev/null << EOF
TYPE=vlan
HOST=$bond2
VID=$vlan2
BOOTPROTO=static
ONBOOT=yes
EOF

 tee $path/ifaces/$bond2/iplink 1>/dev/null << EOF
mtu 9000
EOF
 tee $path/ifaces/$bond2/options 1>/dev/null << EOF
TYPE=bond
ONBOOT=yes
DISABLED=no
NM_CONTROLLED=no
CONFIG_WIRELESS=no
CONFIG_IPV4=yes
CONFIG_IPV6=no
BOOTPROTO=static
HOST="$eth1 $eth2"
BONDMODE=4
BONDOPTIONS="miimon=1 lacp_rate=fast downdelay=0"
EOF

exit 0
}

echo "Generate config network $path"
[ ! -d $path ] || mv /etc/net/ifaces /etc/net/ifaces.$t
[ ! -d $path ] || mkdir -p $path/ifaces

if [[ "$MODE" == "1" ]]; then
    network_only 2 #mode : 1 - 1 ethernet, 2 - 2 ethernet | 2 - MAX!!!!
fi
if [[ "$MODE" == "2" ]]; then
    network_vlan 2
fi
if [[ "$MODE" == "3" ]]; then
    network_bond 2
fi
if [[ "$MODE" == "4" ]]; then
    network_bond_vlan 2
fi
systemctl restart network
exit 0

