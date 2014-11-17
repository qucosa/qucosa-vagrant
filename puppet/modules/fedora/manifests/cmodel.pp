class fedora::cmodel {

  include fedora::apim

  $qucosa_cmodel_version = "1.0-alpha3"
  $qucosa_cmodel_url = "https://github.com/slub/qucosa-fcrepo-contentmodel/archive/${qucosa_cmodel_version}.tar.gz"
  $fedora_home_path = "/opt/fedora"

  exec { "download-qucosa-contentmodel":
    command => "wget ${qucosa_cmodel_url}",
    cwd => "/home/vagrant",
    creates => "/home/vagrant/${qucosa_cmodel_version}.tar.gz"
  }->
  exec { "extract-qucosa-contenmodel":
    command => "tar xf ${qucosa_cmodel_version}.tar.gz",
    cwd => "/home/vagrant",
    creates => "/home/vagrant/qucosa-fcrepo-contentmodel-${qucosa_cmodel_version}"
  }->
  exec { "ingest-qucosa-contentmodel": 
    command => "${fedora_home_path}/client/bin/fedora-ingest.sh d . info:fedora/fedora-system:FOXML-1.1 localhost:8080 fedoraAdmin fedoraAdmin http",
    cwd => "/home/vagrant/qucosa-fcrepo-contentmodel-${qucosa_cmodel_version}/objects",
    environment => ["FEDORA_HOME=${fedora_home_path}"],
    provider => 'shell',
    require => Class['fedora::apim']
  }

}
