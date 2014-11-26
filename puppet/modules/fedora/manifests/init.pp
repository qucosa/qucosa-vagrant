class fedora {
  include tomcat-server
  include fedora::install
  include fedora::cmodel
  include fedora::demo_object
}

