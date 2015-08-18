class fedora::cmodel {
  require fedora::install

  $qucosa_cmodel_version = "1.0.0"
  $qucosa_cmodel_url = "https://github.com/qucosa/qucosa-fcrepo-contentmodel/archive/${qucosa_cmodel_version}.tar.gz"
  $fedora_home_path = "/opt/fedora"
  $fedora_module_path = "/vagrant/puppet/modules/fedora"

  exec { "download-qucosa-contentmodel":
    command => "wget ${qucosa_cmodel_url}",
    cwd     => "/home/vagrant",
    creates => "/home/vagrant/${qucosa_cmodel_version}.tar.gz"
  }->
  exec { "extract-qucosa-contenmodel":
    command => "tar xf ${qucosa_cmodel_version}.tar.gz",
    cwd     => "/home/vagrant",
    creates => "/home/vagrant/qucosa-fcrepo-contentmodel-${qucosa_cmodel_version}"
  }->
  exec { "ingest-qucosa-contentmodel":
    command     => "${fedora_home_path}/client/bin/fedora-ingest.sh d . info:fedora/fedora-system:FOXML-1.1 localhost:8080 fedoraAdmin fedoraAdmin http",
    cwd         => "/home/vagrant/qucosa-fcrepo-contentmodel-${qucosa_cmodel_version}/objects",
    environment => ["FEDORA_HOME=${fedora_home_path}"],
    provider    => 'shell',
    onlyif    => [
      'curl -s -o /dev/null -w "%{http_code}\n" localhost:8080/fedora/objects/qucosa:CModel | grep -v 200',
      "${fedora_module_path}/files/fedora-apim-isalive.sh localhost"
    ]
  }

}
