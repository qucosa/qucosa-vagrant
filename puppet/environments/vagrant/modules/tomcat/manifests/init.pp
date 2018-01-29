class tomcat(
  $package = "tomcat7",
  $service = "tomcat7",
  $jvmopts = ''
) {

  anchor { 'tomcat::_begin': }
  -> Class['tomcat::install']
  ~> Class['tomcat::service']
  -> anchor { 'tomcat::_end': }

  Class { 'tomcat::install':
    package => $package,
    service => $service,
    jvmopts => $jvmopts
  }
  
  Class { 'tomcat::service':
    package => $package,
    service => $service
  }

}
