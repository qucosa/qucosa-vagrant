class mets_dissemination::install {
  require tomcat-server

  $mets_version = "1.0.0"
  $mets_war_url = "https://github.com/qucosa/qucosa-fcrepo-metsdisseminator/releases/download/${mets_version}/qucosa-metsdisseminator-${mets_version}.war"
  $mets_module_path = "/vagrant/puppet/modules/mets_dissemination"
  $fedora_home_path = "/opt/fedora"

  exec { "download-mets-dissemination":
    command => "wget ${mets_war_url} -O mets.war",
    cwd => "${fedora_home_path}/install",
    creates => "${fedora_home_path}/install/mets.war"
  }->
  file { "${fedora_home_path}/install/dissemination.xml":
    source => "${mets_module_path}/files/dissemination.xml"
  }->
  file { '/etc/tomcat7/Catalina/localhost/dissemination.xml':
    ensure => 'link',
    target => "${fedora_home_path}/install/dissemination.xml"
  }
}
