class swordapp::install (
  $sword_home    = undef,
  $sword_version = undef,
  $sword_war_url = undef,
  $tomcat_service = undef
) {

  validate_string($sword_home)
  validate_string($sword_version)
  validate_string($tomcat_service)

  $war          = "swordapp-${sword_version}.war"

  $home         = $sword_home
  $home_bin     = "${home}/bin"
  $home_bin_war = "${home}/bin/${war}"
  $home_config  = "${home}/config"
  $home_lib     = "${home}/lib"
  $home_log     = "${home}/log"

  if ( $sword_war_url != undef ) {
    validate_string($sword_war_url)
    $war_url = $sword_war_url
  } else {
    $war_url = "https://github.com/qucosa/sword-fedora/releases/download/v${sword_version}/sword-fedora-${sword_version}.war"
  }

  File {
    group   => $tomcat_service,
    mode    => 'g+rx'
  }

  file { [ $home, $home_bin, $home_config ]:
    ensure  => directory,
    recurse => true,
  }

  file { $home_lib:
    ensure  => directory,
    purge   => true,
    recurse => true
  }

  file { $home_log:
    ensure  => directory,
    mode    => 'g+rwx'
  }

  file { "${home_config}/log4j.xml":
    ensure  => present,
    content => template('swordapp/log4j.xml.erb')
  }

  exec { 'download-sword':
    command   => "wget ${war_url} -O ${home_bin_war}",
    creates   => $home_bin_war,
    cwd       => $home_bin,
    path      => [ '/bin', '/sbin', '/usr/bin', '/usr/local/bin', '/usr/sbin' ],
    tries     => 6,
    try_sleep => 10,
    require   => File[$home_bin],
  }->file { $home_bin_war: ensure => 'present' }

}
