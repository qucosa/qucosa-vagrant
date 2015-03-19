class saxon::install {
  include tomcat::install, tomcat::service

  $saxon_war_url = 'https://oss.sonatype.org/content/repositories/releases/org/fcrepo/fcrepo-webapp-saxon/3.7.1/fcrepo-webapp-saxon-3.7.1.war'
  $saxon_module_path = '/vagrant/puppet/modules/saxon'
  $fedora_home_path = '/opt/fedora'

  exec { 'download-saxon':
    command => "wget ${saxon_war_url} -O saxon.war",
    cwd     => "${fedora_home_path}/install",
    creates => "${fedora_home_path}/install/saxon.war"
  }->
  file { "${fedora_home_path}/install/saxon.xml":
    source => "${saxon_module_path}/files/saxon.xml"
  }->
  file { '/etc/tomcat7/Catalina/localhost/saxon.xml':
    ensure  => 'link',
    target  => "${fedora_home_path}/install/saxon.xml",
    require => Class['tomcat::install'],
    notify  => Class['tomcat::service']
  }
}
