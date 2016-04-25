[![Build Status](https://travis-ci.org/juju4/ansible-MISP.svg?branch=master)](https://travis-ci.org/juju4/ansible-MISP)
# MISP ansible role

A simple ansible role to setup MISP, Malware Information Sharing Platform & Threat Sharing
http://www.misp-project.org/
https://github.com/MISP/MISP

Alternative
https://blog.rootshell.be/2016/03/03/running-misp-in-a-docker-container/
https://github.com/xme/misp-docker

## Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 2.0

### Operating systems

Tested with vagrant on Ubuntu 14.04, Kitchen test with trusty and centos7 (less for the latter)

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

Once you ensured all necessary roles are present, You can test with:
```
$ cd /path/to/roles/MISP
$ kitchen verify
$ kitchen login
```
or
```
$ cd /path/to/roles/MISP/test/vagrant
$ vagrant up
$ vagrant ssh
```

## Troubleshooting & Known issues

Troubleshooting
```
$ tail /var/log/apache2/misp.*
$ tail /var/www/MISP/app/tmp/logs/error.log
```

Known bugs
* in /var/www/MISP/app/tmp/logs/error.log
Error: [MissingTableException] Table logs for model Log was not found in datasource default.
check misp database exists in mysql and is filled
* PHP Fatal error:  Can't use method return value in write context
Only on centos71 with php54. Ok with ubuntu trusty and php55.
= switch to php56 from remi repository

TODO
* role is not managing upgrade
* monitoring
* hardening
+Viper
https://asciinema.org/a/28808
https://asciinema.org/a/28845

## License

BSD 2-clause


