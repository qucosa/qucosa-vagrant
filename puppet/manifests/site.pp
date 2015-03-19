# Default path for exec resource
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

node 'qucosa.vagrant.dev' {
  include fedora, sword, saxon, qucosa, mets_dissemination

  stage { 'first':
    before => Stage['main']
  }

  # installs openjdk-7-jre-headless on Debian Wheezy
  class { 'java':
    distribution => 'jre',
    stage        => first
  }

}
