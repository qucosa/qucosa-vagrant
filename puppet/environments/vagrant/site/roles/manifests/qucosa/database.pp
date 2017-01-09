class roles::qucosa::database inherits roles::qucosa {
  class { 'profiles::qucosa::postgresql':
    before => Class['profiles::qucosa::fcrepo3']
  }
}
