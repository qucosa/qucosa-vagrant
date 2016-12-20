define oaiprovider::metadataformat ($loc, $uri, $diss, $about = undef) {

  concat::fragment { "proai.properties.metaformat ${name}": 
    content => template('oaiprovider/proai.properties.metaformat.erb'),
    target  => "${::oaiprovider::config::config_dir}/proai.properties",
    order   => '03'
  }

}
