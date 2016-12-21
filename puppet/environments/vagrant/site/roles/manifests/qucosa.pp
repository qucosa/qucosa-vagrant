class roles::qucosa {

  # Installs en, de and default locales via saz/locales module
  class { 'locales':
    default_locale => 'en_US.UTF-8',
    locales        => ['en_US.UTF-8 UTF-8', 'de_DE.UTF-8 UTF-8']
  }

  # Configure network interfaces from Hiera
  $interfaces = hiera('network::interfaces', false)
  if $interfaces {
    class { 'network':
      interfaces_hash => $interfaces
    }
  } else {
    notice('No network interfaces configured in ENC')
  }

  # Configure VM Guest Additions if necessary
  case $::productname {
    'VMware Virtual Platform': { include profiles::vmware::guest }
    default: { notice('Machine is not a VMware Guest') }
  }

}
