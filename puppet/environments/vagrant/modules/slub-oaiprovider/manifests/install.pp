class oaiprovider::install (
  $home_dir    = undef,
  $cache_dir   = undef,
  $session_dir = undef,
  $schema_dir  = undef,
  $version     = undef,
  $war_url     = undef,
  $tomcat_user = undef
) {

  validate_absolute_path($home_dir)
  validate_string($version)
  validate_string($tomcat_user)

  $group    = "qucosa"
  $artifact = "qucosa-fcrepo-oaiprovider"
  $war      = "${artifact}-${version}.war"

  if ( $war_url != undef ) {
    validate_string($war_url)
    $release_url = $war_url
  } else {
    $release_url = "https://github.com/${group}/${artifact}/releases/download/${version}/${war}"
  }

  File {
    group => $tomcat_user,
    mode  => 'g+rwx'
  }

  file { $home_dir:
    ensure  => directory,
    ignore  => [
      $cache_dir,
      $session_dir,
      $schema_dir
    ],
    recurse => true
  }

  $bin_dir = "${home_dir}/bin"

  file { $bin_dir:
    ensure  => directory,
    recurse => true,
    purge   => true
  }

  exec { 'download-war':
    command   => "wget ${release_url} -O ${bin_dir}/${war}",
    creates   => "${bin_dir}/${war}",
    cwd       => $bin_dir,
    path      => [ '/bin', '/sbin', '/usr/bin', '/usr/local/bin', '/usr/sbin' ],
    tries     => 6,
    try_sleep => 10,
    require   => File[$bin_dir],
  }->file { "${bin_dir}/${war}": ensure => present }

}
