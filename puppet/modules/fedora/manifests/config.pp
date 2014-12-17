class fedora::config {

  $fedora_module_path = '/vagrant/puppet/modules/fedora'
  $fedora_home_path = '/opt/fedora'

  file { "${$fedora_home_path}/server/config/fedora-users.xml":
    source  => "${fedora_module_path}/files/fedora-users.xml",
    require => Class['fedora::install']
  }

}
