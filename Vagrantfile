VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "puppetlabs/debian-7.5-64-puppet"
  config.vm.box_url = "https://vagrantcloud.com/puppetlabs/boxes/debian-7.5-64-puppet/versions/1/providers/virtualbox.box"

  config.vm.hostname = "qucosa.app.dev"
  config.vm.network "private_network", type: :dhcp

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file = "site.pp"
    puppet.options = "--verbose"
  end
end
