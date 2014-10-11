class fedora::apim {
  require fedora::install

  $fedora_module_path = "/vagrant/puppet/modules/fedora"
  $fedora_home_path = "/opt/fedora"

  exec { "apim-up":
    command => "${fedora_module_path}/files/fedora-apim-isalive.sh",
    provider => 'shell'
  }
}
