#
class graphite::api::service {

  service { $::graphite::api::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
