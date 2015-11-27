class mets_dissemination::install {
  include fedora::install, tomcat::install, tomcat::service

  $mets_version = '1.2.0'
  $mets_war_url = "https://github.com/qucosa/qucosa-fcrepo-metsdisseminator/releases/download/v${mets_version}/qucosa-metsdisseminator-${mets_version}.war"
  $mets_module_path = '/vagrant/puppet/modules/mets_dissemination'
  $fedora_home_path = '/opt/fedora'

  exec { 'download-mets-dissemination':
    command => "wget ${mets_war_url} -O mets-${mets_version}.war",
    cwd     => "${fedora_home_path}/install",
    creates => "${fedora_home_path}/install/mets-${mets_version}.war",
    require => Class['fedora::install']
  }->
  file { "${fedora_home_path}/install/mets.xml":
    ensure  => file,
    content => template('mets_dissemination/dissemination.xml.erb')
  }->
  file { '/etc/tomcat7/Catalina/localhost/mets.xml':
    ensure  => 'link',
    target  => "${fedora_home_path}/install/mets.xml",
    require => Class['tomcat::install'],
    notify  => Class['tomcat::service']
  }
}
