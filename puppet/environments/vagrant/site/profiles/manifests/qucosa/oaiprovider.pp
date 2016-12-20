class profiles::qucosa::oaiprovider {

  include
    profiles::java7,
    profiles::tomcat

  Class['profiles::java7']->Class['profiles::tomcat']->Class['::oaiprovider']

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

  # Must appear after metaformat type because of compile-time dependencies
  include ::oaiprovider

}
