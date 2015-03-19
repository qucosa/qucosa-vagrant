class fedora {
  include tomcat::service,
    fedora::install,
    fedora::config,
    fedora::cmodel,
    fedora::demo_object
  Class['fedora::install']
    -> Class['fedora::config']
    -> Class['fedora::cmodel']
    -> Class['fedora::demo_object']
    ~> Class['tomcat::service']
}

