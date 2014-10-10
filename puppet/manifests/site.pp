# Default path for exec resource
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

node 'qucosa.app.dev' {
  include fedora
  include sword
  include saxon
}
