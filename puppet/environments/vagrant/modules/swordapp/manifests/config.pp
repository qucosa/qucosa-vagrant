class swordapp::config (

  $host            = undef,
  $pid_namespace   = undef,
  $port            = undef,
  $properties_file = undef,
  $protocol        = undef,

  $external_obj_url = undef,
  $external_ds_url  = undef,
  $deposit_url      = undef

) {

  validate_absolute_path($properties_file)
  validate_integer($port)
  validate_string($host)
  validate_string($pid_namespace)
  validate_string($protocol)

  validate_string($external_obj_url)
  validate_string($external_ds_url)
  validate_string($deposit_url)

  # Fedora config section
  # General config section
  $entry_location        = '/tmp/sword_entries'
  $repository_uri        = "http://${host}:${port}/sword"
  $sub_service_documents = '/sub_service_documents'
  $temp_dir              = '/tmp'

  # Service document section
  $level       = 1
  $noOp        = true
  $verbose     = true

  anchor { 'swordapp::config::_start': }
  -> Swordapp::Workspace <||>
  -> Swordapp::Collection <||>
  -> Swordapp::Filehandler <||>
  -> anchor { 'swordapp::config::_end': }

  concat { $properties_file:
    ensure         => present,
    ensure_newline => true,
    warn           => '<!-- This file is managed by Puppet. DO NOT EDIT. -->',
    require        => Class['swordapp::install']
  }

  Concat::Fragment { target => $properties_file }

  concat::fragment { '0-properties-begin':
    content => '<properties>'
  }

  concat::fragment { '9-properties-end':
    content => '</properties>'
  }

  concat::fragment { '1-fedora':
    content => template('swordapp/properties.fedora.erb')
  }

  concat::fragment { '2-general':
    content => template('swordapp/properties.general.erb')
  }

  concat::fragment { '3-filehandlers-begin':
    content => '    <file_handlers>'
  }

  concat::fragment { '3-filehandlers-end':
    content => '    </file_handlers>'
  }

  concat::fragment { '4-files':
    content => '
    <files>
        <mime-type>WEB-INF/mime-types.xml</mime-type>
    </files>'
  }

  concat::fragment { '5-servicedocument-a':
    content => '    <service_document>'
  }

  concat::fragment { '5-servicedocument-defaults':
    content => template('swordapp/properties.servicedocument.defaults.erb')
  }

  concat::fragment { '5-servicedocument-z':
    content => '    </service_document>'
  }

}
