class profiles::java7 {

  package { [ 'openjdk-6-jre-headless', 'openjdk-6-jre-lib' ]:
    ensure => 'absent'
  }

  package { [ 'openjdk-7-jre-headless', 'openjdk-7-jre-lib' ]:
    ensure => 'present'
  }

}

