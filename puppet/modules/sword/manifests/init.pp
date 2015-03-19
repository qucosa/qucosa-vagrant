class sword {
  include tomcat,
    sword::install,
    sword::filehandler
  Class['tomcat'] -> Class['sword::install'] -> Class['sword::filehandler']
}
