[![Build Status - Master](https://travis-ci.org/juju4/ansible-MISP.svg?branch=master)](https://travis-ci.org/juju4/ansible-MISP)
[![Build Status - Devel](https://travis-ci.org/juju4/ansible-MISP.svg?branch=devel)](https://travis-ci.org/juju4/ansible-MISP/branches)
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

Tested with vagrant on Ubuntu 14.04, Kitchen test with xenial, trusty and centos7

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
* PHP Fatal error:  Can't use method return value in write context
Only on centos71 with php54. Ok with ubuntu trusty and php55.
= switch to php56 from remi repository
* MISP curl_tests.sh is made to run once unlike kitchen verify. If repeated, this test will fail.
* nosetests
.coverage owned by root make the test failing
on ubuntu trusty:
```
$ cd /var/www/MISP/PyMISP && nosetests --with-coverage --cover-package=pymisp tests/test_offline.py
[...]
ImportError: No module named packages.urllib3.response

Name                 Stmts   Miss  Cover
----------------------------------------
pymisp/__init__.py       2      2     0%
pymisp/api.py          782    782     0%
----------------------------------------
TOTAL                  784    784     0%
----------------------------------------------------------------------
Ran 1 test in 0.002s

FAILED (errors=1)
$ dpkg -l |grep urllib3
ii  python-urllib3                   1.7.1-1ubuntu4                   all          HTTP library with thread-safe connection pooling for Python
ii  python-urllib3-whl               1.7.1-1ubuntu4                   all          HTTP library with thread-safe connection pooling
ii  python3-urllib3                  1.7.1-1ubuntu4                   all          HTTP library with thread-safe connection pooling for Python3
```

* if using privileged docker and a host with mysql, you might have the following issue
```
mysqld[29176]: /usr/sbin/mysqld: error while loading shared libraries: libaio.so.1: cannot stat shared object: Permission denied
```
https://github.com/docker/docker/issues/7512

* docker and redis can have issue too and it might be necessary to edit systemd config on xenial
see task 'docker redis workaround ???'

* travis tasks seems to stall in some case like for ubuntu trusty.
Not identified why...


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

