class fedora {
  include tomcat::service,
    fedora::install,
    fedora::config,
    fedora::cmodel,
    fedora::demo_object
}

