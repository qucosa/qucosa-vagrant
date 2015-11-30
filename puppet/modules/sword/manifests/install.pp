class sword::install {
  require tomcat::install
  include tomcat::service

  $sword_version     = '1.6.1'
  $sword_war_url     = "https://github.com/slub/sword-fedora/releases/download/v${sword_version}/sword-fedora-${sword_version}.war"
  $sword_home_path   = '/opt/sword'
  $sword_module_path = '/vagrant/puppet/modules/sword'

  file { [
    $sword_home_path,
    "${sword_home_path}/bin",
    "${sword_home_path}/log",
    "${sword_home_path}/config"
  ]:
    ensure => directory,
    group  => 'tomcat7',
    mode   => 'g+rwx'
  }->
  exec { 'download-sword':
    command => "wget ${sword_war_url} -O sword-${sword_version}.war",
    cwd     => "${sword_home_path}/bin",
    creates => "${sword_home_path}/bin/sword-${sword_version}.war"
  }->
  file { "${sword_home_path}/bin/sword.xml":
    content => template('sword/sword.xml.erb')
  }->
  file { "${sword_home_path}/config/properties.xml":
    source => "${sword_module_path}/files/properties.xml"
  }->
  file { "${sword_home_path}/config/log4j.xml":
    source => "${sword_module_path}/files/log4j.xml"
  }->
  file { '/etc/tomcat7/Catalina/localhost/sword.xml':
    ensure  => 'link',
    target  => "${sword_home_path}/bin/sword.xml",
    notify  => Class['tomcat::service']
  }

  # make sure the lib directory has only managed files
  file { "${sword_home_path}/lib":
    ensure  => directory,
    recurse => true,
    purge   => true,
    group   => 'tomcat7',
    mode    => 'g+rwx'
  }

}
