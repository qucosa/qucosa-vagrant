class oaiprovider::deploy(
  $context_name   = 'oai',
  $tomcat_etc     = undef,
  $war_path       = undef
) {

  validate_absolute_path($tomcat_etc)
  validate_absolute_path($war_path)
  validate_string($context_name)

  $home_dir = "${::oaiprovider::install::home_dir}"
  validate_absolute_path($home_dir)

  file { "${tomcat_etc}/Catalina/localhost/${context_name}.xml":
    ensure  => present,
    content => template('oaiprovider/oaiprovider.xml.erb')
  }

}
