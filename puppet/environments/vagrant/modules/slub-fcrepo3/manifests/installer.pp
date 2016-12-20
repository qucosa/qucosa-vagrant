class fcrepo3::installer {

  $download      = '/opt/fcrepo-download'
  $home          = $fcrepo3::fedora_home
  $installer     = "${download}/${fcrepo3::fedora_installer_bin}"
  $installer_url = "${fcrepo3::fedora_installer_url}/${fcrepo3::fedora_installer_bin}"
  $properties    = "${download}/install.properties"
  $tomcat_etc    = "/etc/${fcrepo3::tomcat_service}/Catalina/localhost"
  $war           = "${home}/install/fedora.war"

  file { '/etc/profile.d/fedora-env.sh':
    content => "export FEDORA_HOME=${home}"
  }

  file { $download:
    ensure => 'directory'
  }

  file { $home:
    recurse   => true,
    group     => $fcrepo3::tomcat_service,
    mode      => 'g+rwx',
    subscribe => Exec['run-installer']
  }

  file { $properties:
    content => template('fcrepo3/install.properties.erb'),
    require => File[$download]
  }

  file { "${tomcat_etc}/fedora.xml":
    ensure    => 'present',
    content   => template('fcrepo3/fedora.xml.erb'),
    subscribe => File[$war],
    notify    => Service[$fcrepo3::tomcat_service]
  }

  Exec {
    path      => [ '/bin', '/sbin', '/usr/bin', '/usr/local/bin', '/usr/sbin' ],
    cwd       => $download,
    try_sleep => 10,
  }

  exec { 'download-installer':
    command  => "wget ${installer_url}",
    creates  => $installer,
    tries    => 6,
    require  => File[$download]
  }->file { $installer: ensure => present }

  exec { 'run-installer':
    command     => "java -jar ${installer} ${properties}",
    creates     => $war,
    subscribe   => File[$installer, $properties],
    require     => File[$installer, $properties]
  }->file { $war: ensure => present }

  $isalive = "${home}/server/bin/fedora-apim-isalive.sh"

  file { $isalive:
    mode   => '+x',
    group  => $fcrepo3::tomcat_package,
    source => 'puppet:///modules/fcrepo3/fedora-apim-isalive.sh'
  }

}

