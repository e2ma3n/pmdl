#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Gitbub : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# pmdl v1.0 - print mikrotik details leases
# Last update : 29-December-2019_14:05:20
# Print all computers which connected to mikrotik using dhcp
# ------------------------------------------------------------------ #

router_ip="$1"

function help {
    echo "[>] Usage:"
    echo "[>]    $0 [mikrotik ip address]"
    echo "[>]    Example: $0 192.168.1.1"
}

function check {
    # check $router_ip is empty or not
    [ -z $router_ip ] && help && exit 1

    # check python-pandas is installed or not
    apt list python-pandas 2> /dev/null | grep -o installed &> /dev/null
    [ "$?" != "0" ] && echo "[#] apt install python-pandas" && exit 1

    # check python-tabulate is installed or not
    apt list python-tabulate 2> /dev/null | grep -o installed &> /dev/null
    [ "$?" != "0" ] && echo "[#] apt install python-tabulate" && exit 1
}

function connection {
    # run command in mikrotik using ssh
    ssh admin@$router_ip 'ip dhcp-server lease print detail' > /tmp/pmdl
    [ "$?" != "0" ] && echo "[!] Can not connect to mikrotik using ssh" && exit 1
    cat /tmp/pmdl | dos2unix > /tmp/pmdl.log
    rm /tmp/pmdl
}

function compute {
    cat /tmp/pmdl.log | grep 'Flags: X - disabled, R - radius, D - dynamic, B - blocked' &> /dev/null
    [ "$?" = "0" ] && sed -i '1d' /tmp/pmdl.log

    echo "comment,address,active-address,mac-address,client-id,active_client_id,active-mac-address,expires-after,last-seen,host_name,status" > /tmp/pmdl.csv

    echo 1 > /tmp/pmdl.temp
    grep -nvP '\S' /tmp/pmdl.log | cut -d ':' -f 1 >> /tmp/pmdl.temp
    count=$(cat /tmp/pmdl.temp | wc -l)
    for (( i=2 ; i <= $count ; i++ )) ; do
        from=$(cat /tmp/pmdl.temp | head -n $i | tail -n 2 | head -n 1)
        until=$(cat /tmp/pmdl.temp | head -n $i | tail -n 2 | tail -n 1)

        data=$(sed -n $from,$until\p /tmp/pmdl.log)

        comment=$(echo "$data" | grep ';;;' | cut -d ';' -f 4)
        [ -z "$comment" ] && comment="-"

        active_address=$(echo "$data" | tr ' ' '\n' | dos2unix | sed '/^$/d' | grep 'active-address=' | cut -d '=' -f 2 | tr -d '"' )
        [ -z "$active_address" ] && active_address="-"

        address=$(echo "$data" | tr ' ' '\n' | dos2unix | sed '/^$/d' | grep '^address=' | cut -d '=' -f 2 | tr -d '"' )
        [ -z "$address" ] && address="-"

        mac_address=$(echo "$data" | tr ' ' '\n' | dos2unix | sed '/^$/d' | grep '^mac-address' | cut -d '=' -f 2 | tr -d '"' )
        [ -z "$mac_address" ] && mac_address="-"

        client_id=$(echo "$data" | tr ' ' '\n' | dos2unix | sed '/^$/d' | grep '^client-id' | cut -d '=' -f 2 | tr -d '"' )
        [ -z "$client_id" ] && client_id="-"

        active_client_id=$(echo "$data" | tr ' ' '\n' | dos2unix | sed '/^$/d' | grep 'active-client-id' | cut -d '=' -f 2 | tr -d '"' )
        [ -z "$active_client_id" ] && active_client_id="-"

        active_mac_address=$(echo "$data" | tr ' ' '\n' | dos2unix | sed '/^$/d' | grep 'active-mac-address' | cut -d '=' -f 2 | tr -d '"' )
        [ -z "$active_mac_address" ] && active_mac_address="-"

        expires_after=$(echo "$data" | tr ' ' '\n' | dos2unix | sed '/^$/d' | grep 'expires-after' | cut -d '=' -f 2 | tr -d '"' )
        [ -z "$expires_after" ] && expires_after="-"

        host_name=$(echo "$data" | tr ' ' '\n' | dos2unix | sed '/^$/d' | grep 'host-name' | cut -d '=' -f 2 | tr -d '"' )
        [ -z "$host_name" ] && host_name="-"

        status=$(echo "$data" | tr ' ' '\n' | dos2unix | sed '/^$/d' | grep 'status' | cut -d '=' -f 2 | tr -d '"' )
        [ -z "$status" ] && status="-"

        last_seen=$(echo "$data" | tr ' ' '\n' | dos2unix | sed '/^$/d' | grep 'last-seen' | cut -d '=' -f 2 | tr -d '"' )
        [ -z "$last_seen" ] && last_seen="-"

        echo "$comment,$address,$active_address,$mac_address,$client_id,$active_client_id,$active_mac_address,$expires_after,$last_seen,$host_name,$status" >> /tmp/pmdl.csv 
    done
}

function c_python {
    # create python script
    echo "import pandas" > /tmp/pmdl.py
    echo "import sys" >> /tmp/pmdl.py
    echo "from tabulate import tabulate" >> /tmp/pmdl.py
    echo "data = pandas.read_csv(sys.argv[1], encoding = 'utf-8' ). fillna('NULL')" >> /tmp/pmdl.py
    echo "print(tabulate(data, headers=data.columns, tablefmt=\"grid\"))" >> /tmp/pmdl.py
}

function view {
    date +"%d-%B-%Y_%T"
    python /tmp/pmdl.py /tmp/pmdl.csv
}

check
connection
compute
c_python
view
rm /tmp/pmdl*
