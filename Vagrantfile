VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "puppetlabs/debian-7.8-64-puppet"
  config.vm.box_version = "1.0.4"

  config.vm.define "standalone"
  config.vm.hostname = "qucosa.vagrant.dev"
  config.vm.network "private_network", type: :dhcp

  if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :box
  end

  if Vagrant.has_plugin?("landrush")
    config.landrush.enabled = true
    config.landrush.tld = "qucosa.vagrant.dev"
  else
    config.vm.network :forwarded_port, guest:8080, host:4711
  end

  config.vm.synced_folder "puppet/environments/vagrant", "/etc/puppetlabs/code/environments/vagrant"

  config.vm.provision "bootstrap", type:"shell" do |shell|
        shell.inline = "apt-get update --fix-missing &&
                        apt-get upgrade -y &&
                        apt-get install git -y &&
                        /opt/puppetlabs/puppet/bin/gem install librarian-puppet &&
                        ln -fs ../puppet/bin/librarian-puppet /opt/puppetlabs/bin/librarian-puppet"
  end

  config.vm.provision "librarian", type:"shell" do |shell|
        shell.inline = "cd /opt/puppetlabs/puppet &&
                        rm -rf Puppetfile modules/ &&
                        librarian-puppet init &&
                        cp /etc/puppetlabs/code/environments/vagrant/Puppetfile . &&
                        librarian-puppet install --verbose"
  end

  config.vm.provision "puppet", type:"shell" do |shell|
        shell.inline = "puppet apply --verbose --debug \
                        /etc/puppetlabs/code/environments/vagrant/manifests/site.pp \
                        --environmentpath=/etc/puppetlabs/code/environments/ --environment=vagrant"
  end
end
