class profiles::tomcat(
  $package = 'tomcat7',
  $service = 'tomcat7',
  $jvmopts = ''
) {

  package { $package:
    ensure          => 'installed',
    install_options => '--no-install-recommends'
  }

  service { $service:
    ensure  => 'running',
    enable  => true,
    require => Package[$package]
  }

  if !empty($jvmopts) {
    file_line { 'Tomcat JVM Options':
      line   => $jvmopts,
      match  => '^JAVA_OPTS=.*',
      notify => Service[$service],
      path   => "/etc/default/${package}"
    }
  }

}
