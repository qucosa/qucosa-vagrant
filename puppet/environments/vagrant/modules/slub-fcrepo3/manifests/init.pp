class fcrepo3 (

  $apia_auth_required = $fcrepo3::params::apia_auth_required,
  $apia_ssl_required  = $fcrepo3::params::apia_ssl_required,
  $apim_ssl_required  = $fcrepo3::params::apim_ssl_required,

  $database                 = $fcrepo3::params::database,
  $database_driver          = $fcrepo3::params::database_driver,
  $database_jdbcDriverClass = $fcrepo3::params::database_jdbcDriverClass,
  $database_jdbcURL         = $fcrepo3::params::database_jdbcURL,
  $database_password        = $fcrepo3::params::database_password,
  $database_username        = $fcrepo3::params::database_username,

  $deploy_local_services = $fcrepo3::params::deploy_local_services,

  $fedora_admin_password = $fcrepo3::params::fedora_admin_password,
  $fedora_home           = $fcrepo3::params::fedora_home,
  $fedora_installer_bin  = $fcrepo3::params::fedora_installer_bin,
  $fedora_installer_url  = $fcrepo3::params::fedora_installer_url,
  $fedora_serverContext  = $fcrepo3::params::fedora_serverContext,
  $fedora_serverHost     = $fcrepo3::params::fedora_serverHost,
  $fedora_version        = $fcrepo3::params::fedora_version,
  $fedora_log_age        = $fcrepo3::params::fedora_log_age,

  $fesl_authz_enabled = $fcrepo3::params::fesl_authz_enabled,

  $messaging_enabled = $fcrepo3::params::messaging_enabled,
  $messaging_uri     = $fcrepo3::params::messaging_uri,

  $ri_enabled = $fcrepo3::params::ri_enabled,

  $ssl_available = $fcrepo3::params::ssl_available,

  $tomcat_home          = $fcrepo3::params::tomcat_home,
  $tomcat_http_port     = $fcrepo3::params::tomcat_http_port,
  $tomcat_package       = $fcrepo3::params::tomcat_package,
  $tomcat_service       = $fcrepo3::params::tomcat_service,
  $tomcat_shutdown_port = $fcrepo3::params::tomcat_shutdown_port,
  $tomcat_ssl_port      = $fcrepo3::params::tomcat_ssl_port,

  $upstream_auth_enabled = $fcrepo3::params::upstream_auth_enabled,

  $xacml_enabled = $fcrepo3::params::xacml_enabled

) inherits fcrepo3::params {

  include fcrepo3::installer,
    fcrepo3::config

  fcrepo3::user { 'fedoraAdmin':
    password => $fcrepo3::fedora_admin_password,
    roles    => [ 'administrator' ]
  }

  fcrepo3::user { 'fedoraIntCallUser':
    password => 'changeme',
    roles    => [ 'fedoraInternalCall-1', 'fedoraInternalCall-2' ]
  }

  tidy { 'tidy client logs':
    path => "${fcrepo3::fedora_home}/client/logs",
    age  => $fcrepo3::fedora_log_age
  }

  tidy { 'tidy server logs':
    path => "$fcrepo3::fedora_home/server/logs",
    age  => $fcrepo3::fedora_log_age
  }

}
