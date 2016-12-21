define swordapp::filehandler (
  $classname = $title,
  $url       = undef,
  $filename  = undef
) {

  if $filename {
    $output_file = $filename
  } else {
    $output_file = "${classname}.jar"
  }

  if $url {
    exec { "download-filehandler-${classname}":
      command   => "wget ${url} -O ${swordapp::install::home_lib}/${output_file}",
      creates   => "${swordapp::install::home_lib}/${output_file}",
      cwd       => $swordapp::install::home_lib,
      path      => [ '/bin', '/sbin', '/usr/bin', '/usr/local/bin', '/usr/sbin' ],
      tries     => 6,
      try_sleep => 10,
      require   => File[$swordapp::install::home_lib]
    }->file{ "${swordapp::install::home_lib}/${output_file}": ensure => present }
  }

  concat::fragment { "3-filehandlers-content-${classname}":
    content => "            <handler class=\"${classname}\" />",
    target  => $swordapp::config::properties_file
  }

}

