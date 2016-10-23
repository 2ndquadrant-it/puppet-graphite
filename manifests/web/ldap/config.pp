#
class graphite::web::ldap::config {

  $bind_dn       = $::graphite::web::ldap::bind_dn
  $bind_password = $::graphite::web::ldap::bind_password
  $conf_dir      = $::graphite::web::conf_dir
  $search_base   = $::graphite::web::ldap::search_base
  $search_filter = $::graphite::web::ldap::search_filter
  $uri           = $::graphite::web::ldap::uri

  ::concat::fragment { "${conf_dir}/local_settings.py ldap":
    content => template("${module_name}/local_settings.py.ldap.erb"),
    order   => '50',
    target  => "${conf_dir}/local_settings.py",
  }
}
