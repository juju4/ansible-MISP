[![Actions Status - Master](https://github.com/juju4/ansible-MISP/workflows/AnsibleCI/badge.svg)](https://github.com/juju4/ansible-MISP/actions?query=branch%3Amaster)
[![Actions Status - Devel](https://github.com/juju4/ansible-MISP/workflows/AnsibleCI/badge.svg?branch=devel)](https://github.com/juju4/ansible-MISP/actions?query=branch%3Adevel)

# MISP ansible role

Ansible role to setup MISP, Malware Information Sharing Platform & Threat Sharing
* http://www.misp-project.org/
* https://github.com/MISP/MISP

Alternatives
* docker: https://blog.rootshell.be/2016/03/03/running-misp-in-a-docker-container/
* rpm: https://github.com/amuehlem/MISP-RPM
https://github.com/xme/misp-docker
* ansible role: https://github.com/MISP/MISP/pull/1413
* ansible role: https://github.com/MISP/MISP/pull/1495

## Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 2.0
 * 2.2
 * 2.3
 * 2.4
 * 2.5

### Operating systems

Tested on Ubuntu 20.04, 22.04 and centos 8-Stream

## Example Playbook

Just include this role in your list.
For example

```
- hosts: all
  roles:
    - juju4.MISP
```

default admin credentials (admin@admin.test / admin)

## Variables

Nothing specific for now.

## Continuous integration

This role has a travis basic test (for github), more advanced with kitchen and also a Vagrantfile (test/vagrant).
Default kitchen config (.kitchen.yml) is lxd-based, while (.kitchen.vagrant.yml) is vagrant/virtualbox based.

Once you ensured all necessary roles are present, You can test with:
```
$ gem install kitchen-ansible kitchen-lxd_cli kitchen-sync kitchen-vagrant
$ cd /path/to/roles/juju4.MISP
$ kitchen verify
$ kitchen login
$ KITCHEN_YAML=".kitchen.vagrant.yml" kitchen verify
```
or
```
$ cd /path/to/roles/juju4.MISP/test/vagrant
$ vagrant up
$ vagrant ssh
```

Role has also a packer config which allows to create image for virtualbox, vmware, eventually digitalocean, lxc and others.
When building it, it's advise to do it outside of roles directory as all the directory is upload to the box during building
and it's currently not possible to exclude packer directory from it (https://github.com/mitchellh/packer/issues/1811)
```
$ cd /path/to/packer-build
$ cp -Rd /path/to/juju4.MISP/packer .
## update packer-*.json with your current absolute ansible role path for the main role
## you can add additional role dependencies inside setup-roles.sh
$ cd packer
$ packer build packer-*.json
$ packer build -only=virtualbox-iso packer-*.json
## if you want to enable extra log
$ PACKER_LOG_PATH="packerlog.txt" PACKER_LOG=1 packer build packer-*.json
## for digitalocean build, you need to export TOKEN in environment.
##  update json config on your setup and region.
$ export DO_TOKEN=xxx
$ packer build -only=digitalocean packer-*.json
## for Azure
$ . ~/.azure/credentials
$ packer build azure-packer-centos7.json
$ packer build -var-file=variables.json azure-packer-centos7.json
```


## Troubleshooting & Known issues

Troubleshooting
```
$ tail /var/log/apache2/misp.*
$ tail /var/www/MISP/app/tmp/logs/*.log
$ cd /var/www/MISP/app/Console && ./cake CakeResque.CakeResque tail
```

Known bugs
* in /var/www/MISP/app/tmp/logs/error.log
Error: [MissingTableException] Table logs for model Log was not found in datasource default.
check misp database exists in mysql and is filled
* MISP curl_tests.sh is made to run once unlike kitchen verify. If repeated, this test will fail.

* if using privileged docker and a host with mysql, you might have the following issue
```
mysqld[29176]: /usr/sbin/mysqld: error while loading shared libraries: libaio.so.1: cannot stat shared object: Permission denied
```
https://github.com/docker/docker/issues/7512

* docker and redis can have issue too and it might be necessary to edit systemd config on xenial
see task 'docker redis workaround ???'

* CI failing sometimes on `Serialization failure: 1213 Deadlock found when trying to get lock; try restarting transaction`. Seems related to [Issue 5004](https://github.com/MISP/MISP/issues/5004) - Open

* Ubuntu 22.04 seems unsupported as php8.1 and app/composer.json requires php >=7.2.0,<8.0.0

* `Error: Database connection \"Mysql\" is missing, or could not be created.` can be cause if multiple php versions are present and wrong version is called from cli.

* `PHP Fatal error: Uncaught TypeError: Return value of Symfony\\Component\\Process\\Process::close() must be of the type int, null returned in phar:///usr/local/bin/composer/vendor/symfony/process/Process.php:1466` (rhel/rockylinux8 and 9): root cause not identified, possibly container/docker related as only failing in molecule/docker and not bare github-hosted images.

* "Error, do this: mount -t proc proc /proc" in /var/log/apache2/error.log: Likely due to misp doing some process listing command requiring /proc (for workers for example) and server build on lxc (including proxmox). Ensure /proc is mounted and no proc restrictions for example at systemd level (InaccessiblePaths) for web user and service.

## FAQ

* usage of roles dependencies like geerlinguy.{mysql,nginx,apache} are not required but allow more fine-tuning.

* To debug gpg issues (as per Server Settings: Diagnostics), refer to
https://github.com/MISP/MISP/issues/413
Target file has changed and is now MISP/app/Model/Server.php

* role is serving MISP as http.
They are other roles to handle certificates like letsencrypt (ex: thefinn93.letsencrypt)
New ansible v2.2 letsencrypt module allow certificate creation but no renewal of task without rerunning role.

* LIEF build can take a while (30-60min) on Centos7. Disable if not needed

* RedHat Selinux references:
  * https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Managing_Confined_Services/sect-Managing_Confined_Services-Configuration_examples-Changing_port_numbers.html
  * https://wiki.centos.org/HowTos/SELinux#head-ad837f60830442ae77a81aedd10c20305a811388

## TODO
* role is not managing upgrade (Work in progress/git pull between minor releases)
* monitoring unless using serverspec
* hardening: apache & nginx hardening is done in separate roles (harden-webserver)
+Viper
https://asciinema.org/a/28808
https://asciinema.org/a/28845

## License

BSD 2-clause
