define swordapp::collection (
  $abstract,
  $accepts,
  $mediation,
  $packaging,
  $pid,
  $policy,
  $treatment,
  $users,
  $workspace
) {

  validate_string($workspace)
  if empty($accepts) {
    fail('Must provide workspace name')
  }

  validate_string($abstract)

  validate_array($accepts)
  if empty($accepts) {
    fail('Must provide accepted media types')
  }

  $deposit_url = $swordapp::config::deposit_url
  validate_string($deposit_url)

  validate_bool($mediation)

  validate_array($packaging)
  if empty($packaging) {
    fail('Must provide accepted SWORD packaging formats')
  }

  validate_string($pid)

  validate_string($policy)

  validate_string($treatment)

  validate_array($users)
  if empty($users) {
    fail('Must provide user names')
  }

  $indent = '                    '
  $prefix = "5-servicedocument-workspace-${workspace}"

  concat::fragment { "${prefix}-collection-${title}":
    content => template('swordapp/properties.collection.erb'),
    target  => $swordapp::config::properties_file
  }

}
