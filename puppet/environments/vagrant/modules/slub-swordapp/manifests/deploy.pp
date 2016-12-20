class swordapp::deploy(
  $tomcat_etc     = undef,
  $tomcat_service = undef
) {

  validate_absolute_path($tomcat_etc)
  validate_string($tomcat_service)

  $home_bin_war = $swordapp::install::home_bin_war
  $home_config  = $swordapp::install::home_config
  $home_lib     = $swordapp::install::home_lib

  file { "${swordapp::tomcat_etc}/Catalina/localhost/sword.xml":
    ensure    => present,
    content   => template('swordapp/sword.xml.erb'),
    # HACK Creates dependency cycle as Tomcat service is
    # precondition for swordapp::install
    #    notify    => Service[$tomcat_service],
  }

}
