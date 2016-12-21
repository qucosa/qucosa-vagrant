class swordapp::params {

  $fedora_host          = 'localhost'
  $fedora_pid_namespace = 'sword'
  $fedora_port          = '8080'
  $fedora_protocol      = 'http'

  $external_obj_url     = "http://${fedora_host}:${fedora_port}/fedora/get/##PID##"
  $external_ds_url      = "http://${fedora_host}:${fedora_port}/fedora/get/##PID##/##DS##"
  $deposit_url          = "http://${fedora_host}:${fedora_port}/sword/##COLLECTION_PID##"

  $sword_home     = '/opt/sword'
  $sword_version  = '1.5.6'

  $tomcat_etc     = '/etc/tomcat7'
  $tomcat_service = 'tomcat7'

}
