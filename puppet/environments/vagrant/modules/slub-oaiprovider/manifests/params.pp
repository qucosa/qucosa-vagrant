class oaiprovider::params {

  $home_dir = '/opt/oaiprovider'
  $version  = '1.2.0-rc4'

  $tomcat_user = 'tomcat7'

  $proai_cacheBaseDir     = '/opt/oaiprovider/cache'
  $proai_sessionBaseDir   = '/opt/oaiprovider/sessions'
  $proai_schemaDir        = '/opt/oaiprovider/schemas'
  $proai_validate_updates = true

  $driver_fedora_baseUrl  = 'http://localhost:8080/fedora'
  $driver_fedora_user     = 'fedoraAdmin'
  $driver_fedora_pass     = 'fedoraAdmin'
  $driver_fedora_identify = 'http://localhost:8080/fedora/get/qucosa:OAI/Identify'

}
