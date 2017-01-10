class roles::qucosa::oaiprovider inherits roles::qucosa {
  require roles::qucosa::appserver
  include profiles::qucosa::oaiprovider
}
