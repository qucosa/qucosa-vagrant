class tomcat::install {
  package { 'tomcat7':
    ensure          => installed,
    install_options => '--no-install-recommends'
  }
}

