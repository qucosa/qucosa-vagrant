# Default path for exec resource
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

node 'qucosa.app.dev' {
  include fedora
  include sword
  include saxon

  # installs openjdk-7-jre-headless on Debian Wheezy
  class { 'java':
    distribution => 'jre'
  }

  class { 'elasticsearch':
    manage_repo => true,
    repo_version => '1.3',
    require => Class['java']
  }

  elasticsearch::instance { 'es-qucosa-dev': }

  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf':
    module_dir => 'kopf',
    instances => 'es-qucosa-dev'
  }

  elasticsearch::plugin { 'fedora-river':
    module_dir => 'fedora-river',
    url => 'https://github.com/slub/elasticsearch-river-fedora/releases/download/v1.0.0/fedora-river-1.0.0.zip',
    instances => 'es-qucosa-dev',
    notify => Elasticsearch::Service['es-qucosa-dev']
  }

}
