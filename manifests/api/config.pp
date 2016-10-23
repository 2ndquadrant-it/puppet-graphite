#
class graphite::api::config {

  $address              = $::graphite::api::address
  $allowed_origins      = $::graphite::api::allowed_origins
  $carbon_hosts         = $::graphite::api::carbon_hosts
  $carbon_metric_prefix = $::graphite::api::carbon_metric_prefix
  $carbon_retry_delay   = $::graphite::api::carbon_retry_delay
  $carbon_timeout       = $::graphite::api::carbon_timeout
  $conf_file            = $::graphite::api::conf_file
  $group                = $::graphite::api::group
  $package_name         = $::graphite::api::package_name
  $port                 = $::graphite::api::port
  $render_errors        = $::graphite::api::render_errors
  $replication_factor   = $::graphite::api::replication_factor
  $service_name         = $::graphite::api::service_name
  $state_dir            = $::graphite::api::state_dir
  $time_zone            = $::graphite::api::time_zone
  $user                 = $::graphite::api::user
  $whisper_dir          = $::graphite::api::whisper_dir
  $workers              = $::graphite::api::workers

  ::concat { $conf_file:
    owner => 0,
    group => 0,
    mode  => '0644',
    warn  => "# !!! Managed by Puppet !!!\n",
  }

  ::concat::fragment { "${conf_file} header":
    content => template("${module_name}/graphite-api.yaml.header.erb"),
    order   => '01',
    target  => $conf_file,
  }

  ::concat::fragment { "${conf_file} footer":
    content => template("${module_name}/graphite-api.yaml.footer.erb"),
    order   => '99',
    target  => $conf_file,
  }

  group { $group:
    ensure => present,
    system => true,
  }

  user { $user:
    ensure => present,
    gid    => $group,
    system => true,
  }

  file { $state_dir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0644',
  }

  case $::osfamily {
    'RedHat': {
      file { '/etc/sysconfig/graphite-api':
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0644',
        content => template("${module_name}/sysconfig.erb"),
      }
    }
    default: {}
  }
}
