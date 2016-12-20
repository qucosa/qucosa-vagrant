define fcrepo3::user (
  $username = $title,
  $password = undef,
  $roles    = 'user'
) {

  if !$password {
    fail('You need to supply a password')
  }

  validate_array($roles)

  concat::fragment { "2-user-${title}":
    content => template('fcrepo3/user.xml.erb'),
    target  => "${fcrepo3::fedora_home}/server/config/fedora-users.xml"
  }

}
