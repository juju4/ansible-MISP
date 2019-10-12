#!/bin/sh
## one script to be used by travis, jenkins, packer...

umask 022

if [ $# != 0 ]; then
rolesdir=$1
else
rolesdir=$(dirname $0)/..
fi

[ ! -d $rolesdir/juju4.redhat_epel ] && git clone https://github.com/juju4/ansible-redhat-epel $rolesdir/juju4.redhat_epel
[ ! -d $rolesdir/geerlingguy.nginx ] && git clone https://github.com/geerlingguy/ansible-role-nginx.git $rolesdir/geerlingguy.nginx
[ ! -d $rolesdir/geerlingguy.apache ] && git clone https://github.com/geerlingguy/ansible-role-apache.git $rolesdir/geerlingguy.apache
#[ ! -d $rolesdir/geerlingguy.mysql ] && git clone https://github.com/geerlingguy/ansible-role-mysql.git $rolesdir/geerlingguy.mysql
[ ! -d $rolesdir/juju4.harden_apache ] && git clone https://github.com/juju4/ansible-harden-apache $rolesdir/juju4.harden_apache
[ ! -d $rolesdir/juju4.harden_nginx ] && git clone https://github.com/juju4/ansible-harden-nginx $rolesdir/juju4.harden_nginx
#[ ! -d $rolesdir/w3af ] && git clone https://github.com/juju4/ansible-w3af $rolesdir/w3af
## galaxy naming: kitchen fails to transfer symlink folder
#[ ! -e $rolesdir/juju4.MISP ] && ln -s ansible-MISP $rolesdir/juju4.MISP
[ ! -e $rolesdir/juju4.misp ] && cp -R $rolesdir/ansible-MISP $rolesdir/juju4.misp
[ ! -e $rolesdir/juju4.misp ] && cp -R $rolesdir/juju4.MISP $rolesdir/juju4.misp

## don't stop build on this script return code
true

