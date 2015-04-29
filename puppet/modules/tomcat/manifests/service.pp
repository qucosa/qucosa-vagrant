class tomcat::service {
  service { 'tomcat7':
    ensure  => running,
    enable  => true,
    require => Class['tomcat::install']
  }
}

