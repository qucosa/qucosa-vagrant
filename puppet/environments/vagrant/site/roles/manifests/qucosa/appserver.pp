class roles::qucosa::appserver inherits roles::qucosa {
  require roles::qucosa::database
  include profiles::qucosa::fcrepo3
}
