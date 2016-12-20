class profiles::nas {

    package { 'nfs-common':
      ensure          => 'present',
      install_options => ['--no-install-recommends']
    }

    file { '/mnt/nas_storage':
      ensure => directory
    }

}
