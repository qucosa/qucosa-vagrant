class qucosa {
  include fedora, qucosa::search
  Class['fedora'] -> Class['qucosa::search']
}
