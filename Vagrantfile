VAGRANTFILE_API_VERSION = "2"

$post_up_message = <<-MSG
------------------------------------------------------
Local Qucosa Repository, accessible at localhost (127.0.0.1)

URLS:
- Fedora            - http://localhost:4711/fedora/
- Tomcat Manager    - http://localhost:4711/manager/html
- SWORDv1 provider  - http://localhost:4711/sword
- Elasticsearch     - http://localhost:4712/
- ES Kopf Plugin    - http://localhost:4712/_plugin/kopf
- ActiveMQ          - tcp://localhost:4713
------------------------------------------------------
MSG

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.hostname = "qucosa"
    config.vm.box = "debian/stretch64"

    # Force vagrant to mount shared folder instead of using troubled rsync
    config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

    config.vm.network :forwarded_port, guest:8080, host:4711  # Tomcat
    config.vm.network :forwarded_port, guest:9200, host:4712  # Elasticsearch
    config.vm.network :forwarded_port, guest:61616, host:4713 # ActiveMQ

    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus   = 2
    end

    config.vm.provision "upgrade", type: "shell" do |shell|
        shell.inline = "apt-get update --fix-missing &&
                        apt-get upgrade -y &&
                        apt-get autoremove &&
                        apt-get autoclean"
    end

    config.vm.provision "ansible", type: "ansible_local" do |ansible|
        ansible.become = true
        ansible.playbook = "ansible/playbook.yml"
        ansible.compatibility_mode = "2.0"
    end

    config.vm.post_up_message = $post_up_message

end
