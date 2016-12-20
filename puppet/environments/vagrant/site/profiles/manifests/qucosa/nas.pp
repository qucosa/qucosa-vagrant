class profiles::qucosa::nas (
  $netapp_interface = undef,
  $netapp_volume = undef
) inherits profiles::nas {

  if $netapp_interface == undef {
    fail("netapp_interface must be defined for environment: ${environment}")
  }

  if $netapp_volume == undef {
    fail("netapp_volume must be defined for environment: ${environment}")
  }

  mount { '/mnt/nas_storage':
    ensure  => 'mounted',
    atboot  => true,
    device  => "${netapp_interface}:${netapp_volume}",
    fstype  => 'nfs',
    options => 'rw,soft,auto',
    require => [
      Package['nfs-common'],
      File['/mnt/nas_storage']
    ]
  }

}

