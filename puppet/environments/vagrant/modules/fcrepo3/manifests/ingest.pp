define fcrepo3::ingest (

    $format,
    $type,

    $context         = $fcrepo3::serverContext,
    $log             = undef,
    $path            = $title,
    $pid             = '*',
    $refreshonly     = false,
    $source_host     = undef,
    $source_password = undef,
    $source_port     = undef,
    $source_protocol = 'http',
    $source_user     = undef,
    $target_host     = $fcrepo3::fedora_serverHost,
    $target_password = $fcrepo3::fedora_admin_password,
    $target_port     = $fcrepo3::tomcat_http_port,
    $target_protocol = 'http',
    $target_user     = 'fedoraAdmin'
) {

  validate_bool($refreshonly)

  if !($type in ['directory', 'file', 'repository']) {
    fail("Unkown type: `${type}`")
  }

  if !($format in [
    'info:fedora/fedora-system:FOXML-1.1',
    'info:fedora/fedora-system:FOXML-1.0',
    'info:fedora/fedora-system:METSFedoraExt-1.1',
    'info:fedora/fedora-system:METSFedoraExt-1.0',
    'info:fedora/fedora-system:ATOM-1.1',
    'info:fedora/fedora-system:ATOMZip-1.1']) {
    fail("Unknown format: `${format}`")
  }

  $mode = $type ? {
    'directory'  => 'd',
    'file'       => 'f',
    'repository' => 'r'
  }

  $executable = "${fcrepo3::fedora_home}/client/bin/fedora-ingest.sh ${mode}"

  if $type == 'repository' {
    $options_target = "${target_host}:${target_port} ${target_user} ${target_password}"
    $options_source = "${source_host}:${source_port} ${source_user} ${source_password}"
    $command = "${executable} ${options_source} ${options_target} ${source_protocol} ${target_protocol}"
  } else {
    $options_target = "${target_host}:${target_port} ${target_user} ${target_password} ${target_protocol}"
    $command = "${executable} ${path} ${format} ${options_target}"
  }

  $isalive = "${fcrepo3::fedora_home}/server/bin/fedora-apim-isalive.sh"

  exec { "ingest-${title}":
    command     => "${command} ${log} ${context}",
    environment => ["FEDORA_HOME=${fcrepo3::fedora_home}"],
    onlyif      => "${$isalive} ${target_host} ${target_port}",
    provider    => 'shell',
    refreshonly => $refreshonly,
    require     => File[$isalive]
  }

}
