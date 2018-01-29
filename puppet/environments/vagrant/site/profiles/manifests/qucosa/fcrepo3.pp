class profiles::qucosa::fcrepo3(

  $kitodo_publication_api = undef,
  $qucosa_purl_url        = undef,
  $use_nas                = true

) {
  include
    profiles::java7,
    '::fcrepo3'

  if $use_nas {
    include profiles::qucosa::nas
  } else {
    notify { 'NAS disabled. Data is stored locally.': }
  }

  if $kitodo_publication_api == undef {
    fail("kitodo_publication_api must be defined for environment: ${environment}")
  }

  if $qucosa_purl_url == undef {
    fail("qucosa_purl_url must be defined for environment: ${environment}")
  }

  Class['profiles::java7']
  ->Class['profiles::qucosa::postgresql']
  ->Class['::tomcat::install']
  ->Class['::fcrepo3']
  ~>Class['::tomcat::service']

  Class { '::tomcat':
    package => 'tomcat7',
    service => 'tomcat7',
    jvmopts => 'JAVA_OPTS="-Djava.awt.headless=true -Xms1024m -Xmx1024m -XX:+UseConcMarkSweepGC -XX:MaxPermSize=512m"'
  }

  if $use_nas {
    file { '/mnt/nas_storage/fcrepo3':
      ensure  => directory,
      owner   => 'tomcat7',
      group   => 'tomcat7',
      mode    => 'ug+rwx',
      require => [
        Package['tomcat7'],
        Mount['/mnt/nas_storage']
      ]
    }

    file { "${::fcrepo3::fedora_home}/data":
      ensure  => link,
      target  => '/mnt/nas_storage/fcrepo3',
      force   => true,
      require => [
        Class['::fcrepo3'],
        File['/mnt/nas_storage/fcrepo3']
      ]
    }
  }

  fcrepo3::user { 'sword':
    password => 'sword',
    roles    => [ 'administrator' ]
  }

  $qucosa_git_url = 'https://github.com/qucosa'

  $mets_version   = '2.0.1'
  $mets_war_name  = "qucosa-metsdisseminator-${mets_version}.war"
  fcrepo3::service { 'mets':
    source       => "${qucosa_git_url}/qucosa-fcrepo-metsdisseminator/releases/download/v${mets_version}/${mets_war_name}",
    warfile_name => $mets_war_name,
    parameters   => {
      'fedora.host.url' => "http://${::fcrepo3::fedora_serverHost}:8080/${::fcrepo3::fedora_serverContext}"
    }
  }

  $epicur_version  = '1.1.4'
  $epicur_war_name = "qucosa-epicurdisseminator-${epicur_version}.war"
  fcrepo3::service { 'epicur':
    source       => "${qucosa_git_url}/qucosa-fcrepo-epicurdisseminator/releases/download/v${epicur_version}/${epicur_war_name}",
    warfile_name => $epicur_war_name,
    parameters   => {
      'transfer.url.pattern' => "${kitodo_publication_api}/##PID##/attachment/##DSID##/",
      'transfer.url.pidencode' => 'yes',
      'frontpage.url.pattern' => "${qucosa_purl_url}/##PID##"
    }
  }

  fcrepo3::service { 'saxon':
    source       => 'puppet:///modules/profiles/qucosa/saxon.war',
    warfile_name => 'saxon.war'
  }

  $qucosa_cmodel_version  = '1.2.4'
  $qucosa_cmodel_url      = "https://github.com/qucosa/qucosa-fcrepo-contentmodel/archive/${qucosa_cmodel_version}.tar.gz"
  $qucosa_cmodel_filename = "qucosa-fcrepo-contentmodel-${qucosa_cmodel_version}"

  exec { 'download-qucosa-contentmodel':
    command => "wget ${qucosa_cmodel_url} -O ${qucosa_cmodel_filename}.tar.gz",
    cwd     => '/tmp',
    creates => "/tmp/${qucosa_cmodel_filename}.tar.gz"
  }->
  exec { 'extract-qucosa-contentmodel':
    command => "tar xf ${qucosa_cmodel_filename}.tar.gz",
    cwd     => '/tmp',
    creates => "/tmp/${qucosa_cmodel_filename}"
  }

  fcrepo3::ingest { "/tmp/${qucosa_cmodel_filename}/objects":
    type        => 'directory',
    format      => 'info:fedora/fedora-system:FOXML-1.1',
    subscribe   => Exec['extract-qucosa-contentmodel'],
    refreshonly => true
  }

  $qucosa_oai_filename = 'qucosa_OAI.foxml'

  file { "/tmp/${qucosa_oai_filename}":
    source => "puppet:///modules/profiles/qucosa/${qucosa_oai_filename}"
  }

  fcrepo3::ingest { "/tmp/${qucosa_oai_filename}":
    type        => 'file',
    format      => 'info:fedora/fedora-system:FOXML-1.1',
    subscribe   => File["/tmp/${qucosa_oai_filename}"],
    refreshonly => true
  }

}
