[![Build Status](https://travis-ci.org/juju4/ansible-MISP.svg?branch=master)](https://travis-ci.org/juju4/ansible-MISP)
# MISP ansible role

Ansible role to setup MISP, Malware Information Sharing Platform & Threat Sharing
http://www.misp-project.org/
https://github.com/MISP/MISP

Alternatives
* docker: https://blog.rootshell.be/2016/03/03/running-misp-in-a-docker-container/
https://github.com/xme/misp-docker
* ansible role: https://github.com/MISP/MISP/pull/1413
* ansible role: https://github.com/MISP/MISP/pull/1495

## Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 2.0

### Operating systems

Tested with vagrant on Ubuntu 14.04, Kitchen test with xenial, trusty and centos7

## Example Playbook

Just include this role in your list.
For example

```
- host: all
  roles:
    - MISP
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
$ cd /path/to/roles/MISP
$ kitchen verify
$ kitchen login
$ KITCHEN_YAML=".kitchen.vagrant.yml" kitchen verify
```
or
```
$ cd /path/to/roles/MISP/test/vagrant
$ vagrant up
$ vagrant ssh
```

Role has also a packer config which allows to create image for virtualbox, vmware, eventually digitalocean, lxc and others.
When building it, it's advise to do it outside of roles directory as all the directory is upload to the box during building 
and it's currently not possible to exclude packer directory from it (https://github.com/mitchellh/packer/issues/1811)
```
$ cd /path/to/packer-build
$ cp -Rd /path/to/MISP/packer .
## update packer-*.json with your current absolute ansible role path for the main role
## you can add additional role dependencies inside setup-roles.sh
$ cd packer
$ packer build packer-*.json
$ packer build -only=virtualbox packer-*.json
## if you want to enable extra log
$ PACKER_LOG=1 packer build packer-*.json
## for digitalocean build, you need to export TOKEN in environment.
##  update json config on your setup and region.
$ export DO_TOKEN=xxx
$ packer build -only=digitalocean packer-*.json
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

## FAQ

* usage of roles dependencies like geerlinguy.{mysql,nginx,apache} are not required but allow more fine-tuning.


## TODO
* role is not managing upgrade
* monitoring unless using serverspec
* hardening: apache & nginx hardening is done in separate roles (harden-webserver)
+Viper
https://asciinema.org/a/28808
https://asciinema.org/a/28845

## License

BSD 2-clause

