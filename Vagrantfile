VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "puppetlabs/debian-7.6-64-puppet"
  config.vm.box_url = "https://vagrantcloud.com/puppetlabs/boxes/debian-7.6-64-puppet/versions/1.0.0/providers/virtualbox.box"

  config.vm.hostname = "qucosa.app.dev"
  config.vm.network "private_network", type: :dhcp

  config.vm.provision "shell" do |shell|
        shell.inline = "puppet module install puppetlabs-stdlib;
                        puppet module install puppetlabs-apt;
                        puppet module install puppetlabs-java;
                        puppet module install elasticsearch-elasticsearch"
  end

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "site.pp"
    puppet.options = [ "--modulepath=/vagrant/puppet/modules:/etc/puppet/modules", "--verbose", "--debug" ]
  end
end
