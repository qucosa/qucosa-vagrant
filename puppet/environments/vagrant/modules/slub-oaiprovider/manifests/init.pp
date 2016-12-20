class oaiprovider (

  $home_dir = $oaiprovider::params::home_dir,
  $version  = $oaiprovider::params::version,

  $tomcat_user = $oaiprovider::params::tomcat_user,

  $proai_cacheBaseDir     = $oaiprovider::params::proai_cacheBaseDir,
  $proai_sessionBaseDir   = $oaiprovider::params::proai_sessionBaseDir,
  $proai_schemaDir        = $oaiprovider::params::proai_schemaDir,
  $proai_validate_updates = $oaiprovider::params::proai_validate_updates,

  $driver_fedora_baseUrl  = $oaiprovider::params::driver_fedora_baseUrl,
  $driver_fedora_user     = $oaiprovider::params::driver_fedora_user,
  $driver_fedora_pass     = $oaiprovider::params::driver_fedora_pass,
  $driver_fedora_identify = $oaiprovider::params::driver_fedora_identify

) inherits oaiprovider::params {

  anchor { 'oaiprovider::_begin': }
  -> Class['oaiprovider::install']
  -> Class['oaiprovider::config']
  -> Class['oaiprovider::deploy']
  -> anchor { 'oaiprovider::_end': }

  oaiprovider::metadataformat { 'oai_dc':
    loc   => 'http://www.openarchives.org/OAI/2.0/oai_dc.xsd',
    uri   => 'http://www.openarchives.org/OAI/2.0/oai_dc/',
    diss  => 'info:fedora/*/oai_dc',
    about => 'info:fedora/*/about_oai_dc'
  }

  class { 'oaiprovider::install':
    home_dir    => $home_dir,
    cache_dir   => $proai_cacheBaseDir,
    session_dir => $proai_sessionBaseDir,
    schema_dir  => $proai_schemaDir,
    version     => $version,
    tomcat_user => 'tomcat7'
  }

  class { 'oaiprovider::config':
    fedora_url       => $driver_fedora_baseUrl,
    fedora_user      => $driver_fedora_user,
    fedora_pass      => $driver_fedora_pass,
    validate_updates => $proai_validate_updates
  }

  class { 'oaiprovider::deploy':
    context_name   => 'oai',
    tomcat_etc     => '/etc/tomcat7',
    war_path       => "${::oaiprovider::install::bin_dir}/${::oaiprovider::install::war}"
  }

}
