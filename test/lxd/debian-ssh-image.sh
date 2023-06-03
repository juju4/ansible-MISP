#!/bin/sh
# add ssh to default lxd debian image

guest=default-$image
template="$image"-nossh
publishalias="$image"

lxc init $template $guest
lxc start $guest
openssl rand -base64 48 | perl -ne 'print "$_" x2' | lxc exec $guest -- passwd root

lxc exec $guest -- dhclient eth0
lxc exec $guest -- ping -c 1 8.8.8.8
lxc exec $guest -- apt-get -y update
lxc exec $guest -- apt-get -y upgrade
lxc exec $guest -- apt-get install -y openssh-server sudo
lxc exec $guest -- mkdir /root/.ssh || true

lxc stop $guest --force
lxc publish $guest --alias $publishalias
lxc delete $guest
