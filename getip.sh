#!/bin/sh

# List running Virtual Boxes and their IPs

list_vms=`VBoxManage list runningvms | grep -oP '(?<={).*(?=})'`

for id in $list_vms
do
    name=`vboxmanage list runningvms | grep $id`
    ip=`vboxmanage guestproperty get $id '/VirtualBox/GuestInfo/Net/1/V4/IP'`
    echo $name $ip
done


