#!/bin/bash -eux
## from https://github.com/geerlingguy/packer-ubuntu-1404/blob/master/scripts/setup.sh

# Add vagrant user to sudoers.
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

