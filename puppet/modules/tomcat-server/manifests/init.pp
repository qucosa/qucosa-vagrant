class tomcat-server {
    package { 'tomcat7':
        ensure => installed,
        install_options => '--no-install-recommends'
    }
    service { 'tomcat7':
        ensure => running,
        require => Package['tomcat7']
    }
}

