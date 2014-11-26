class fedora::demo_object {

  include fedora::apim

  $fedora_module_path = "/vagrant/puppet/modules/fedora"
  $fedora_home_path   = "/opt/fedora"
  $qucosa_object_path = "${fedora_module_path}/files/qucosa_1_atom.zip"

  exec { "ingest-qucosa-demo":
    command => "${fedora_home_path}/client/bin/fedora-ingest.sh f ${qucosa_object_path} info:fedora/fedora-system:ATOMZip-1.1 localhost:8080 fedoraAdmin fedoraAdmin http",
    environment => ["FEDORA_HOME=${fedora_home_path}"],
    provider => 'shell',
    require => Class['fedora::apim']
  }

}
