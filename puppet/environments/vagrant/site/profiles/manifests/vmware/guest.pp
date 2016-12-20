class profiles::vmware::guest {

  package { 'open-vm-tools':
    ensure          => installed,
    install_options => '--no-install-recommends'
  }

  package { ['isc-dhcp-client', 'isc-dhcp-common', 'mpt-status']:
    ensure  => purged
  }

}

