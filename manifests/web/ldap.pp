#
class graphite::web::ldap (
  String $uri,
  String $search_base,
  String $bind_dn,
  String $bind_password,
  String $search_filter,
  String $package_name = $::graphite::web::params::ldap_package_name,
) inherits ::graphite::web::params {

  if ! defined(Class['::graphite::web']) {
    fail('You must include the graphite::web base class before using the graphite::web::redis class')
  }

  validate_ldap_uri($uri)
  validate_ldap_dn($search_base)
  validate_ldap_dn($bind_dn)
  validate_ldap_filter($search_filter)

  include ::graphite::web::ldap::install
  include ::graphite::web::ldap::config

  Anchor['graphite::web::begin'] -> Class['::graphite::web::ldap::install']
    ~> Class['::graphite::web::ldap::config'] -> Anchor['graphite::web::end']
}
