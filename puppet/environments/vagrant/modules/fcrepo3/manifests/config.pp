class fcrepo3::config {

  $fedora_users_xml = "${fcrepo3::fedora_home}/server/config/fedora-users.xml"

  concat { $fedora_users_xml:
    ensure         => present,
    ensure_newline => true,
    require        => Class['fcrepo3::installer']
  }

  Concat::Fragment { target => $fedora_users_xml }

  concat::fragment { '0-prolog':
    content => '<?xml version="1.0" encoding="UTF-8"?>'
  }

  concat::fragment { '0-prolog-warn':
    content => '<!-- This file is managed by Puppet. DO NOT EDIT. -->'
  }

  concat::fragment { '1-users':
    content => '<users>'
  }

  concat::fragment { '3-users':
    content => '</users>'
  }

}
