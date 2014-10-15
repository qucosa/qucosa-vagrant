class qucosa::search {

  class { 'elasticsearch':
    manage_repo  => true,
    repo_version => '1.3'
  }

  elasticsearch::instance { 'es-qucosa-dev': }

  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf':
    module_dir => 'kopf',
    instances  => 'es-qucosa-dev'
  }

  elasticsearch::plugin { 'fedora-river':
    module_dir => 'fedora-river',
    url        => 'https://github.com/slub/elasticsearch-river-fedora/releases/download/v1.0.0/fedora-river-1.0.0.zip',
    instances  => 'es-qucosa-dev'
  }

  exec { 'yellow-status':
    command  => '/vagrant/puppet/modules/qucosa/files/elasticsearch-cluster-status.sh localhost yellow',
    provider => 'shell',
    require  => Service['elasticsearch-es-qucosa-dev']
  }

  exec { 'fedora-river-meta':
    command   => 'curl -XPOST -H"content-type:application/json" -d @/vagrant/puppet/modules/qucosa/files/fedora-river.json http://localhost:9200/_river/fedora/_meta',
    provider  => 'shell',
    subscribe => Elasticsearch::Plugin['fedora-river'],
    require   => [
      Class['fedora'],
      Exec['yellow-status']
    ]
  }

}

