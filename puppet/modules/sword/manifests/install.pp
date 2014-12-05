class sword::install {
  require tomcat-server

  $sword_war_url = "https://github.com/slub/sword-fedora/releases/download/v1.4.0/sword-fedora-1.4.0-slub.war"
  $sword_home_path = "/opt/sword"
  $sword_module_path = "/vagrant/puppet/modules/sword"

  file { [
    "${sword_home_path}", 
    "${sword_home_path}/bin",
    "${sword_home_path}/log",
    "${sword_home_path}/config"
  ]:
    ensure => 'directory',
    group => tomcat7,
    mode => "g+rwx"
  }->
  exec { "download-sword":
    command => "wget ${sword_war_url} -O sword.war",
    cwd => "${sword_home_path}/bin",
    creates => "${sword_home_path}/bin/sword.war"
  }->
  file { "${sword_home_path}/bin/sword.xml":
    source => "${sword_module_path}/files/sword.xml"
  }->
  file { "${sword_home_path}/config/properties.xml":
    source => "${sword_module_path}/files/properties.xml"
  }->
  file { "${sword_home_path}/config/log4j.xml":
    source => "${sword_module_path}/files/log4j.xml"
  }->
  file { '/etc/tomcat7/Catalina/localhost/sword.xml':
    ensure => 'link',
    target => "${sword_home_path}/bin/sword.xml"
  }
}
