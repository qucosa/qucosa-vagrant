class roles::qucosa::oaiprovider inherits roles::qucosa {
  class { 'profiles::qucosa::oaiprovider':
    require => Class['profiles::qucosa::fcrepo3']
  }
}
