define fcrepo3::service (

  $parameters   = {},
  $path         = $title,
  $source       = undef,
  $warfile_name = undef

) {

  if $title !~ /^[\w\-\_]+$/ {
    fail("Service name `${title}` is not allowed (Only letters, minus and underscore characters are accepted)")
  }

  if $warfile_name == undef {
    fail('Need to specify warfile_name')
  }

  if !is_hash($parameters) {
    fail('The `parameters` parameter is not a hash')
  }

  $docBase = "${fcrepo3::fedora_home}/install/${warfile_name}"

  if $source != undef {
    if $source =~ /^puppet:/ {

      file { $docBase:
        ensure  => file,
        source  => $source,
        require => Class['fcrepo3::installer'],
        before  => File["context-${title}"]
      }

    } else {

      exec { "download-${title}":
        command => "wget ${source} -O ${warfile_name}",
        cwd     => "${fcrepo3::fedora_home}/install",
        creates => $docBase,
        require => Class['fcrepo3::installer'],
        before  => File["context-${title}"]
      }

    }
  }

  file { "context-${title}":
    ensure  => file,
    path    => "${fcrepo3::tomcat_home}/conf/Catalina/localhost/${title}.xml",
    content => template('fcrepo3/tomcat-context.xml.erb'),
    require => Class['fcrepo3::installer'],
  }

}
