class profiles::qucosa::elasticsearch (
  $elasticsearch_instance = 'es-qucosa-default',
  $elasticsearch_replicas = '0',
  $elasticsearch_heapsize = '1g',

  $fedora_url      = 'http://localhost:8080/fedora',
  $fedora_username = 'fedoraAdmin',
  $fedora_password = 'fedoraAdmin',
  $jms_broker_url  = 'failover:(tcp://localhost:61616)'

) {

  include
    profiles::java7

  $river_version = '1.1.1'
  $river_disturl = 'https://github.com/qucosa/elasticsearch-river-fedora/releases/download'
  $river_release = "${river_disturl}/v${river_version}/fedora-river-${river_version}.zip"

  $kopf_version  = '1.5.0'

  $elasticsearch_release = '1.3'

  class { '::elasticsearch':
    autoupgrade  => true,
    config       => {
      'cluster.name'             => $elasticsearch_instance,
      'index.number_of_replicas' => $elasticsearch_replicas
    },
    manage_repo  => true,
    repo_version => $elasticsearch_release
  }

  elasticsearch::instance { $elasticsearch_instance:
    init_defaults => {
      'ES_HEAP_SIZE' => $elasticsearch_heapsize
    }
  }

  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf':
    url        => "https://github.com/lmenezes/elasticsearch-kopf/archive/v${kopf_version}.zip",
    instances  => $elasticsearch_instance
  }

  elasticsearch::plugin { 'fedora-river':
    url        => $river_release,
    instances  => $elasticsearch_instance
  }

  file { '/opt/fedora-river.json':
    ensure  => present,
    content => template('profiles/qucosa/fedora-river.json.erb'),
    mode    => '0644'
  }

  exec { 'fedora-river-meta':
    command     => 'curl -XPOST -H"content-type:application/json" -d @/opt/fedora-river.json http://localhost:9200/_river/fedora/_meta',
    provider    => 'shell',
    refreshonly => true,
    subscribe   => File['/opt/fedora-river.json'],
    onlyif      => [
      "curl -s -o /dev/null -w '%{http_code}\n' --retry 3 ${fedora_url}/describe | grep 200",
      "curl -s -o /dev/null -w '%{http_code}\n' --retry 3 'http://localhost:9200/_cluster/health?wait_for_status=yellow&timeout=4m' | grep 200"
    ],
    require     => [
      Elasticsearch::Instance[$elasticsearch_instance],
      Elasticsearch::Plugin['fedora-river']
    ]
  }

}
