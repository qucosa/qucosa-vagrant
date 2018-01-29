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
3. Run the `getip.sh` script to obtain the IP of the VM just started
4. Connect your browser to http://`IP_OF_VM`:8080/fedora/describe and see the
   Repository Description Page.
   Check the Elasticsearch installation via http://`IP_OF_VM`:9200
5. Also, there is port forwarding to `localhost:4711` for accessing Tomcat and
   `localhost:4712 for Elasticsearch`
6. Please consult the [Known Issues](#known-issues) section.

## DNS support

If your Vagrant has the [landrush](https://github.com/phinze/landrush) plugin installed, the machine should be available via its hostname. For example: http://qucosa.vagrant.dev:8080/fedora.

However, installing `landrush` might turn out a bit tricky, since it needs to install and build additional Ruby gems. Make sure you have Ruby, G++ development and `dnsmasq` environments installed properly on your host:

- [Unable to install gem - Failed to build gem native extension - cannot load such file — mkmf (LoadError)](http://stackoverflow.com/questions/13767725/unable-to-install-gem-failed-to-build-gem-native-extension-cannot-load-such).
- [Visibility on the Host](https://github.com/phinze/landrush#visibility-on-the-host)

## Cache support

The file has support for [vagrant-cachier](https://github.com/fgrehm/vagrant-cachier) to speed up package download. You can install `vagrant-cachier` simply with ```$ vagrant plugin install vagrant-cachier```. Check the project website for detailed information.

# Known Issues

## VirtualBox Guest Additions not installed or outdated

If you get the following message when you do ```vagrant up``` means that the Virtual Guest Additions are not installed or outdated:

```
==> default: Checking for guest additions in VM...
    default: No guest additions were detected on the base box for this VM! Guest
    default: additions are required for forwarded ports, shared folders, host only
    default: networking, and more. If SSH fails on this machine, please install
    default: the guest additions and repackage the box to continue.
    default: 
    default: This is not an error message; everything may continue to work properly,
```
Fortunately there is the Vagrant plugin ```vagrant-vbguest``` that helps you with the installation of the VirtualBox Guest Additions. To install go to the directory that contains the ```Vagrantfile``` and type the following command depending on your Vagrant version:

- Vagrant >= 1.1.5: ```$ vagrant plugin install vagrant-vbguest```
- Vagrant < 1.1.5: ```$ vagrant gem install vagrant-vbguest```

Further information: http://kvz.io/blog/2013/01/16/vagrant-tip-keep-virtualbox-guest-additions-in-sync/

## VirtualBox DHCP server won't start
If `vagrant up` failes with some error regarding host only adapter, check here for
a workaround: https://github.com/berngp/docker-zabbix/issues/8

## Vagrant cannot mount folder

If you run Vagrant on VirtualBox 4.3.10 you might get the following message when you do ```vagrant up```:

```
Failed to mount folders in Linux guest. This is usually beacuse
the "vboxsf" file system is not available. Please verify that
the guest additions are properly installed in the guest and
can work properly. The command attempted was:

mount -t vboxsf -o uid=`id -u vagrant`,gid=`getent group vagrant | cut -d: -f3` /vagrant /vagrant
mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` /vagrant /vagrant
```

This is due to a [VirtualBox bug](https://www.virtualbox.org/ticket/12879) which is fixed for the 4.3.12 release. To make it work for VirtualBox 4.3.10, you will need to apply a workaround manually after ```vagrant ssh```:

```
sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
```

After that run ```vagrant reload --provision``` to continue with the provisioning.

**Note:** You will have to do this every time you rebuild the VM after calling ```vagrant destroy```.

