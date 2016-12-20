class profiles::qucosa::postgresql {

  $database = 'fedora3'
  $username = 'fedoraAdmin'
  $password = 'fedoraAdmin'

  class { 'postgresql::server':
    listen_addresses        => '*',
    ip_mask_allow_all_users => '0.0.0.0/0',
  }

  postgresql::server::db { $database:
    user      => $username,
    password  => $password,
    encoding  => 'UTF8'
  }

  postgresql::server::pg_hba_rule { $database:
    address     => '0.0.0.0/0',
    auth_method => 'md5',
    database    => $database,
    type        => 'host',
    user        => $username
  }

}

