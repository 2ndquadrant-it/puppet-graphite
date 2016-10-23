#
class graphite::api::redis::config {

  $conf_file  = $::graphite::api::conf_file
  $database   = $::graphite::api::redis::database
  $host       = $::graphite::api::redis::host
  $key_prefix = $::graphite::api::redis::key_prefix
  $password   = $::graphite::api::redis::password
  $port       = $::graphite::api::redis::port
  $timeout    = $::graphite::api::redis::timeout

  ::concat::fragment { "${conf_file} cache":
    content => template("${module_name}/graphite-api.yaml.redis.erb"),
    order   => '50',
    target  => $conf_file,
  }
}
