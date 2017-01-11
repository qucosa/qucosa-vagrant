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
    config.vm.network :forwarded_port, guest:9200, host:4712
  end

  config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus   = 2
  end

  config.vm.synced_folder "puppet/environments/vagrant", "/etc/puppetlabs/code/environments/vagrant"

  config.vm.provision "bootstrap", type:"shell" do |shell|
        shell.inline = "apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 7F438280EF8D349F &&
                        apt-get update --fix-missing &&
                        apt-get upgrade -y &&
                        apt-get install git ruby -y &&
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

  # HACK Restart Tomcat container to ensure webapps start *after* database
  config.vm.provision "restart", type:"shell", run:"always" do |shell|
        shell.inline = "if (dpkg -s tomcat7); then service tomcat7 restart; fi"
  end

  config.vm.provision "puppet", type:"shell", run:"never" do |shell|
        shell.inline = "puppet apply --verbose \
                        /etc/puppetlabs/code/environments/vagrant/manifests/site.pp \
                        --environmentpath=/etc/puppetlabs/code/environments/ --environment=vagrant"
  end

end
