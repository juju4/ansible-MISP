# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- Travis: force test-kitchen 0.1.25 to keep compatibility with kitchen-lxd_cli
- Travis: dist from trusty to xenial + lxd3
https://blog.travis-ci.com/2018-11-08-xenial-release
- Travis: rvm 2.6
- Travis: remove testing of Ubuntu 16.04 as recent MISP/PyMISP/misp-modules updates requires python 3.6. Only 3.5 available in normal distribution.
- Github: rename tags to match semantic versioning: 0.7.0, 0.8.0
- misp-modules dependencies update
- update patch to support php strict
- more linting
- handlers to manage services inside docker

## [0.9.0] - 2019-02-17

### Added
- Gitignore
- test/default+nginx: include juju4.harden-apache or juju4.harden-nginx
- packer: Azure configuration

### Changed
- Heavy lint following galaxy new rules following adoption of ansible-lint
https://groups.google.com/forum/#!topic/ansible-project/ehrb6AEptzA
https://docs.ansible.com/ansible-lint/rules/default_rules.html
https://github.com/ansible/ansible-lint
- PyIntel471: not supported on Xenial - python 3.6 required
- test/default (apache): switch to https by default - self-signed certificate
- snuffleupagus support (php7 hardening)
- update galaxy naming (juju4.MISP -> juju4.misp, redhat_epel, harden_apache...)
- redis hardening (rename-command) - password protection triggers issue [TODO]
- Centos/RHEL7: fix multiple issues

## [v0.8] - 2018-06-17

### Added
- LIEF support: https://github.com/lief-project/LIEF.git
- Centos/RHEL: selinux support, php-opcache
- PyMISP verifycert option
- git signed commit retrieve support (not enforced as not all commits are signed)
- Jenkinsfile: extra testing with zap, arachni...

### Changed

## [v0.7] - 2017-01-30

### Added
- Initial commit on Github, include simple travis, kitchen and vagrant tests
- Jenkinsfile
- packer: Virtualbox, Vmware configurations
