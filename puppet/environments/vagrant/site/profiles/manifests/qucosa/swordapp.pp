class profiles::qucosa::swordapp {

  $sword_version = '1.6.3'
  $qucosa_filehandler_version = '1.4.5'

  $release_url = 'https://github.com/qucosa/qucosa-sword-filehandler/releases/download'
  $release_jar = "qucosa-sword-filehandler-${qucosa_filehandler_version}.jar"
  $classname   = 'org.purl.sword.server.fedora.fileHandlers.QucosaMETSFileHandler'
  $workspace = 'Qucosa SWORD workspace'

  include
    profiles::java7,
    profiles::tomcat

  Class['profiles::java7']->Class['profiles::tomcat']->Class['::swordapp']

  class { '::swordapp':
    sword_version => $sword_version
  }

  swordapp::workspace { $workspace: }

  swordapp::collection { 'Qucosa General Collection':
    abstract  => 'This is a collection of all Qucosa objects',
    accepts   => [ 'application/vnd.qucosa.mets+xml' ],
    mediation => true,
    packaging => [ 'http://www.loc.gov/METS/' ],
    pid       => 'qucosa:all',
    policy    => 'This collection accepts any deposit on behalf of the `sword` user',
    treatment => 'Preservation actions may occur on submited deposits',
    users     => [ 'sword' ],
    workspace => $workspace
  }

  swordapp::collection { 'Qucosa SLUB Collection':
    abstract  => 'This is a collection of all SLUB objects',
    accepts   => [ 'application/vnd.qucosa.mets+xml' ],
    mediation => true,
    packaging => [ 'http://www.loc.gov/METS/' ],
    pid       => 'qucosa:slub',
    policy    => 'This collection accepts any deposit on behalf of the `slub` user',
    treatment => 'Preservation actions may occur on submited deposits',
    users     => [ 'slub' ],
    workspace => $workspace
  }

  swordapp::filehandler { $classname:
    url      => "${release_url}/v${qucosa_filehandler_version}/${release_jar}",
    filename => $release_jar
  }

  # One of the default file handlers
  swordapp::filehandler { 'org.purl.sword.server.fedora.fileHandlers.ZipMETSFileHandler': }

}

