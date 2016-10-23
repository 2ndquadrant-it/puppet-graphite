#
class graphite::web::install {

  package { $::graphite::web::package_name:
    ensure => present,
  }

  if $::graphite::web::memcache_hosts {
    include ::memcached::python
  }
}
