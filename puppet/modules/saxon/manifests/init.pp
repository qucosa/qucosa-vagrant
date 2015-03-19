class saxon {
  include tomcat, saxon::install
  Class['tomcat'] -> Class['saxon::install']
}
