#!/bin/sh
## one script to be used by travis, jenkins, packer...

umask 022

if [ $# != 0 ]; then
rolesdir=$1
else
rolesdir=$(dirname $0)/..
fi

[ ! -d $rolesdir/juju4.redhat-epel ] && git clone https://github.com/juju4/ansible-redhat-epel $rolesdir/juju4.redhat-epel
[ ! -d $rolesdir/geerlingguy.nginx ] && git clone https://github.com/geerlingguy/ansible-role-nginx.git $rolesdir/geerlingguy.nginx
[ ! -d $rolesdir/geerlingguy.apache ] && git clone https://github.com/geerlingguy/ansible-role-apache.git $rolesdir/geerlingguy.apache
#[ ! -d $rolesdir/geerlingguy.mysql ] && git clone https://github.com/geerlingguy/ansible-role-mysql.git $rolesdir/geerlingguy.mysql
#[ ! -d $rolesdir/w3af ] && git clone https://github.com/juju4/ansible-w3af $rolesdir/w3af

