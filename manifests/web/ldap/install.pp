#
class graphite::web::ldap::install {

  package { $::graphite::web::ldap::package_name:
    ensure => present,
  }
}
