# Vagrant File for Qucosa Repository system

Uses [Vagrant](https://www.vagrantup.com/) to spin up a developer friendly
VirtualBox VM containing a fully configured Qucosa Repository system.

## Requirements

- Git
- VirtualBox
- Vagrant
- Quick Internet connection (because it's going to download a lot of stuff)

## Usage

1. Clone the Git repository
2. Run `vagrant up` to install, run and provision the Virtual Machine.
3. There is port forwarding to `localhost:4711` for accessing Tomcat and
   `localhost:4712 for Elasticsearch`
