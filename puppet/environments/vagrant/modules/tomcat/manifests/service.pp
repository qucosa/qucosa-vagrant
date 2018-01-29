class tomcat::service(
  $package = "tomcat7",
  $service = "tomcat7"
) {

  service { $service:
    ensure  => 'running',
    enable  => true,
    require => Package[$package]
  }

}
