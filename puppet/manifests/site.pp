# Default path for exec resource
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

node default {
  include fedora, sword, mets_dissemination
  include qucosa::search

  stage { 'first':
    before => Stage['main']
  }

  # installs openjdk-7-jre-headless on Debian Wheezy
  class { 'java':
    distribution => 'jre',
    stage        => first
  }

}
