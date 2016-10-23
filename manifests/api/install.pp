#
class graphite::api::install {

  package { $::graphite::api::package_name:
    ensure => present,
  }
}
