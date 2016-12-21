define swordapp::workspace {

  $indent = '            '

  Concat::Fragment { target => $swordapp::config::properties_file }

  concat::fragment { "5-servicedocument-workspace-${title}-begin":
    content => "${indent}<workspace title=\"${title}\">" }

  concat::fragment { "5-servicedocument-workspace-${title}-end":
    content => "${indent}</workspace>" }
}

