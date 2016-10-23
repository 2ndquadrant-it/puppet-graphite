#
class graphite::api::redis::install {

  package { $::graphite::api::redis::package_name:
    ensure => present,
  }
}
