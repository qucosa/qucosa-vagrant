class fedora::install {
  include tomcat::install, tomcat::service

  require tomcat::install

  $fedora_module_path = '/vagrant/puppet/modules/fedora'
  $fedora_home_path = '/opt/fedora'
  $fcrepo_installer_url = 'https://github.com/slub/fcrepo/releases/download/v3.8.0-slub-p1'
  $fcrepo_installer_jar = 'fcrepo-installer-3.8.0.jar'

  file { '/etc/profile.d/fedora-env.sh':
    source => "${fedora_module_path}/files/fedora-env.sh"
  }->
  exec { 'download-fcrepo-installer':
    command => "wget ${fcrepo_installer_url}/${fcrepo_installer_jar}",
    cwd     => '/home/vagrant',
    creates => "/home/vagrant/${fcrepo_installer_jar}"
  }->
  exec { 'fcrepo-installer':
    command => "java -jar /home/vagrant/${fcrepo_installer_jar} ${fedora_module_path}/files/install.properties",
    cwd     => '/home/vagrant',
    creates => "${fedora_home_path}/install/fedora.war"
  }->
  file { "${fedora_home_path}/install/fedora.xml":
    source => "${fedora_module_path}/files/fedora.xml"
  }->
  file { "${fedora_home_path}":
    recurse => true,
    group   => "tomcat7",
    mode    => "g+rwx"
  }->
  file { '/etc/tomcat7/Catalina/localhost/fedora.xml':
    ensure  => 'link',
    target  => "${fedora_home_path}/install/fedora.xml",
    notify  => Class['tomcat::service']
  }
}
