# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
