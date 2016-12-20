class oaiprovider::config (

  $fedora_url  = undef,
  $fedora_user = 'fedoraAdmin',
  $fedora_pass = 'fedoraAdmin',

  $validate_updates = true
) {

  $home_dir = "${::oaiprovider::install::home_dir}"
  validate_absolute_path($home_dir)

  validate_string($fedora_url)

  $config_dir = "${home_dir}/config"

  file { $config_dir:
    ensure  => directory,
    recurse => true
  }

  file { "${config_dir}/logback.xml":
    ensure => present,
    source => 'puppet:///modules/oaiprovider/logback.xml'
  }

  file { "${config_dir}/mckoi.conf":
    ensure => present,
    source => 'puppet:///modules/oaiprovider/mckoi.conf'
  }

  concat { "${config_dir}/proai.properties":
    ensure         => present,
    ensure_newline => true,
    warn           => '# This file is managed by Puppet. DO NOT EDIT.',
    require        => File[$config_dir]
  }

  concat::fragment { 'proai.properties':
    content => template('oaiprovider/proai.properties.erb'),
    target  => "${config_dir}/proai.properties",
    order   => '01'
  }

  concat::fragment { 'proai.properties.metaformats':
    content => template('oaiprovider/proai.properties.metaformats.erb'),
    target  => "${config_dir}/proai.properties",
    order   => '02'
  }-> Oaiprovider::Metadataformat <||>
}
