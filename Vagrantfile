VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "puppetlabs/debian-7.6-64-puppet"
  config.vm.box_url = "https://vagrantcloud.com/puppetlabs/boxes/debian-7.6-64-puppet/versions/1.0.0/providers/virtualbox.box"

  config.vm.define "standalone"
  config.vm.hostname = "qucosa.vagrant.dev"
  config.vm.network "private_network", type: :dhcp

  if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :box
  end

  if Vagrant.has_plugin?("landrush")
    config.landrush.enabled = true
  end

  config.vm.provision "shell" do |shell|
        shell.inline = "apt-get update --fix-missing;
                        apt-get upgrade -y;
                        puppet module install puppetlabs-stdlib;
                        puppet module install puppetlabs-apt --force -v 1.8.0;
                        puppet module install puppetlabs-java;
                        puppet module install elasticsearch-elasticsearch"
  end

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "site.pp"
    puppet.options = [ "--modulepath=/vagrant/puppet/modules:/etc/puppet/modules", "--verbose" ]
  end
end
