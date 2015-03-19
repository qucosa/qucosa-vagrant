class tomcat {
  include tomcat::install, tomcat::service
  Class['tomcat::install'] ~> Class['tomcat::service']
}

