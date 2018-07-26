class profiles::qucosa::oaiprovider {

  include
    profiles::java7

  Class['profiles::java7']
  ->Class['::tomcat::install']
  ->Class['::oaiprovider']
  ~>Class['::tomcat::service']

  #  oaiprovider::metadataformat { 'mets':
  #    loc   => 'http://www.loc.gov/standards/mets/mets.xsd',
  #    uri   => 'http://www.loc.gov/METS/',
  #    diss  => 'info:fedora/*/qucosa:SDef/getMETSDissemination'
  #  }

  oaiprovider::metadataformat { 'epicur':
    loc  => 'http://www.persistent-identifier.de/xepicur/version1.0/xepicur.xsd',
    uri  => 'urn:nbn:de:1111-2004033116',
    diss => 'info:fedora/*/qucosa:SDef/getEpicurDissemination'
  }

  oaiprovider::metadataformat { 'xmetadissplus':
    loc  => 'http://www.d-nb.de/standards/xmetadiss/xmetadiss.xsd',
    uri  => 'http://www.d-nb.de/standards/xMetaDiss/',
    diss => 'info:fedora/*/qucosa:SDef/xMetaDissPlusDissemination'
  }

  # Must appear after metaformat type because of compile-time dependencies
  include ::oaiprovider

}
