class profiles::puppet::agent {

    file {'/etc/puppet/auth.conf':
        source => 'puppet:///modules/profiles/puppet/auth.conf'
    }

    file {'/etc/puppet/namespaceauth.conf':
        ensure => present
    }

    file {'/etc/puppet/puppet.conf':
        content => template('profiles/puppet/puppet.conf.erb'),
        require => [
            File['/etc/puppet/auth.conf'],
            File['/etc/puppet/namespaceauth.conf'] ]
    }

    service {'puppet':
        ensure    => running,
        enable    => true,
        subscribe => File['/etc/puppet/puppet.conf']
    }

    # Use herculesteam/augeasproviders_ssh to permit root login
    sshd_config { 'PermitRootLogin':
      ensure => present,
      value  => 'no',
    }

}

