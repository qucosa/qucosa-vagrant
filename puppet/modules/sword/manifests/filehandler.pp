class sword::filehandler {

  $version = '1.1.0'
  $url     = "https://github.com/qucosa/qucosa-sword-filehandler/releases/download/v${version}/qucosa-sword-filehandler-${version}.jar"

  $sword_lib_path = '/opt/sword/lib'

  exec { 'download':
    command => "wget ${$url} -O ${sword_lib_path}/qucosa-filehandler-${version}.jar",
    cwd     => "${sword_lib_path}",
    creates => "${sword_lib_path}/qucosa-filehandler-${version}.jar",
    require => Class['sword::install']
  }

}
