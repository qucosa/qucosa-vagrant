class qucosa::search {
  require fedora::install

  class { 'elasticsearch':
    manage_repo  => true,
    repo_version => '1.3'
  }

  elasticsearch::instance { 'es-qucosa-dev': }

  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf':
    module_dir => 'kopf',
    url        => 'https://github.com/lmenezes/elasticsearch-kopf/archive/v1.4.9.zip',
    instances  => 'es-qucosa-dev',
  }

  elasticsearch::plugin { 'fedora-river':
    module_dir => 'fedora-river',
    url        => 'https://github.com/slub/elasticsearch-river-fedora/releases/download/v1.1.0/fedora-river-1.1.0.zip',
    instances  => 'es-qucosa-dev'
  }

  exec { 'fedora-river-meta':
    command   => 'curl -XPOST -H"content-type:application/json" -d @/vagrant/puppet/modules/qucosa/files/fedora-river.json http://localhost:9200/_river/fedora/_meta',
    provider  => 'shell',
    onlyif    => [
      '/vagrant/puppet/modules/fedora/files/fedora-apim-isalive.sh localhost',
      '/vagrant/puppet/modules/qucosa/files/elasticsearch-cluster-status.sh localhost yellow',
      'curl -s -o /dev/null -w "%{http_code}\n" localhost:9200/_river/fedora/_status | grep -v 200',
    ],
    require   => [
      Elasticsearch::Instance['es-qucosa-dev'],
      Elasticsearch::Plugin['fedora-river']
    ]
  }

}

