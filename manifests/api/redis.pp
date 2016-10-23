#
class graphite::api::redis (
  String            $host,
  Integer[0]        $database     = 0,
  String            $key_prefix   = $::graphite::api::params::cache_key_prefix,
  String            $package_name = $::graphite::api::params::redis_package_name,
  Optional[String]  $password     = undef,
  Integer[0, 65535] $port         = 6379,
  Integer[0]        $timeout      = $::graphite::api::params::cache_timeout,
) inherits ::graphite::api::params {

  if ! defined(Class['::graphite::api']) {
    fail('You must include the graphite::api base class before using the graphite::api::redis class')
  }

  include ::graphite::api::redis::install
  include ::graphite::api::redis::config

  Class['::graphite::api::install'] -> Class['::graphite::api::redis::install']
    -> Class['::graphite::api::redis::config']
}
