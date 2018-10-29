#
class graphite::api::params inherits ::graphite::params {

  $cache_key_prefix = 'graphite-api'
  $cache_timeout    = 60

  case $::osfamily {
    'RedHat': {
      $address            = '127.0.0.1'
      $conf_file          = '/etc/graphite-api.yaml'
      $group              = 'graphite-api'
      $package_name       = 'graphite-api'
      $port               = 8888
      $redis_package_name = 'python-redis'
      $service_name       = 'graphite-api'
      $state_dir          = '/var/lib/graphite-api'
      $user               = 'graphite-api'
      $whisper_dir        = $::graphite::params::whisper_dir
      $workers            = 4
    }
    'Debian': {
      $address            = '127.0.0.1'
      $conf_file          = '/etc/graphite-api.yaml'
      $group              = '_graphite'
      $package_name       = 'graphite-api'
      $port               = 8888
      $redis_package_name = 'python-redis'
      $service_name       = 'graphite-api'
      $state_dir          = '/var/lib/graphite-api'
      $user               = '_graphite'
      $whisper_dir        = $::graphite::params::whisper_dir
      $workers            = 4
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
