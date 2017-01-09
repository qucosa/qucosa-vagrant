class swordapp (

  $fedora_host          = $swordapp::params::fedora_host,
  $fedora_pid_namespace = $swordapp::params::fedora_pid_namespace,
  $fedora_port          = $swordapp::params::fedora_port,
  $fedora_protocol      = $swordapp::params::fedora_protocol,

  $external_obj_url     = $swordapp::params::external_obj_url,
  $external_ds_url      = $swordapp::params::external_ds_url,
  $deposit_url          = $swordapp::params::deposit_url,

  $sword_home     = $swordapp::params::sword_home,
  $sword_version  = $swordapp::params::sword_version,

  $tomcat_etc     = $swordapp::params::tomcat_etc,
  $tomcat_service = $swordapp::params::tomcat_service

) inherits swordapp::params {

  anchor { 'swordapp::_begin': }
  -> Class['swordapp::install']
  -> Class['swordapp::config']
  -> Class['swordapp::deploy']
  -> anchor { 'swordapp::_end': }

  class { 'swordapp::install':
    sword_home     => $sword_home,
    sword_version  => $sword_version,
    tomcat_service => $tomcat_service
  }

  class { 'swordapp::config':
    host             => $fedora_host,
    pid_namespace    => $fedora_pid_namespace,
    port             => $fedora_port,
    properties_file  => "${sword_home}/config/properties.xml",
    protocol         => $fedora_protocol,
    external_obj_url => $external_obj_url,
    external_ds_url  => $external_ds_url,
    deposit_url      => $deposit_url
  }

  class { 'swordapp::deploy':
    tomcat_etc     => $tomcat_etc,
    tomcat_service => $tomcat_service
  }

}
