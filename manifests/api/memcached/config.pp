#
class graphite::api::memcached::config {

  $conf_file  = $::graphite::api::conf_file
  $key_prefix = $::graphite::api::memcached::key_prefix
  $servers    = $::graphite::api::memcached::servers
  $timeout    = $::graphite::api::memcached::timeout

  ::concat::fragment { "${conf_file} cache":
    content => template("${module_name}/graphite-api.yaml.memcached.erb"),
    order   => '50',
    target  => $conf_file,
  }
}
