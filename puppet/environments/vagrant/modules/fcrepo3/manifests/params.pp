class fcrepo3::params {
  $fedora_home           = '/opt/fedora'
  $fedora_version        = '3.8.1-jdk7'
  $fedora_installer_bin  = "fcrepo-installer-${fedora_version}.jar"
  $fedora_installer_url  = "https://github.com/qucosa/qucosa-fcrepo3/releases/download/v${fedora_version}"
  $fedora_log_age        = '5w'

  $tomcat_package = 'tomcat7'
  $tomcat_service = 'tomcat7'

  # Installer params to be fed into install.properties.erb

  $apia_auth_required = false
  $apia_ssl_required  = false
  $apim_ssl_required  = false

  $database_driver          = 'included'
  $database_jdbcDriverClass = 'org.apache.derby.jdbc.EmbeddedDriver'
  $database_jdbcURL         = 'jdbc\:derby\:/opt/fedora/derby/fedora3;create\=true'
  $database_password        = 'fedoraAdmin'
  $database_username        = 'fedoraAdmin'
  $database                 = 'included'

  $deploy_local_services = false

  $fedora_admin_password = 'fedoraAdmin'
  $fedora_serverContext  = 'fedora'
  $fedora_serverHost     = 'localhost'

  $fesl_authz_enabled = false

  $messaging_enabled = true
  $messaging_uri     = "vm\:(broker\:(tcp\://${fedora_serverHost}\:61616))"

  $ri_enabled = true

  $ssl_available = true

  $tomcat_home          = "/var/lib/${tomcat_service}"
  $tomcat_http_port     = '8080'
  $tomcat_shutdown_port = '8005'
  $tomcat_ssl_port      = '8443'

  $upstream_auth_enabled = false

  $xacml_enabled = false
}

