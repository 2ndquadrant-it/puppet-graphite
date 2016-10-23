#
class graphite::api::memcached (
  Array[
    Struct[
      {
        'host' => String,
        'port' => Integer[0, 65535],
      }
    ],
    1
  ]          $servers,
  String     $key_prefix = $::graphite::api::params::cache_key_prefix,
  Integer[0] $timeout    = $::graphite::api::params::cache_timeout,
) inherits ::graphite::api::params {

  if ! defined(Class['::graphite::api']) {
    fail('You must include the graphite::api base class before using the graphite::api::memcached class')
  }

  include ::graphite::api::memcached::install
  include ::graphite::api::memcached::config

  Class['::graphite::api::install']
    -> Class['::graphite::api::memcached::install']
    -> Class['::graphite::api::memcached::config']
}
