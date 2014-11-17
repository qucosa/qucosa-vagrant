# Default path for exec resource
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

node 'qucosa.app.dev' {

  # installs openjdk-7-jre-headless on Debian Wheezy
  class { 'java': distribution => 'jre' }

  include fedora,
    sword,
    saxon,
    qucosa,
    mets_dissemination
}
