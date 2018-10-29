#
class graphite::web::config {

  $allowed_hosts                  = $::graphite::web::allowed_hosts
  $carbonlink_hosts               = $::graphite::web::carbonlink_hosts
  $carbonlink_query_bulk          = $::graphite::web::carbonlink_query_bulk
  $carbonlink_timeout             = $::graphite::web::carbonlink_timeout
  $cluster_servers                = $::graphite::web::cluster_servers
  $conf_dir                       = $::graphite::web::conf_dir
  $databases                      = $::graphite::web::databases
  $debug                          = $::graphite::web::debug
  $default_cache_duration         = $::graphite::web::default_cache_duration
  $documentation_url              = $::graphite::web::documentation_url
  $flushrrdcached                 = $::graphite::web::flushrrdcached
  $graphite_root                  = $::graphite::web::graphite_root
  $http_server                    = $::graphite::web::http_server
  $log_cache_performance          = $::graphite::web::log_cache_performance
  $log_dir                        = $::graphite::web::log_dir
  $log_metric_access              = $::graphite::web::log_metric_access
  $log_rendering_performance      = $::graphite::web::log_rendering_performance
  $memcache_hosts                 = $::graphite::web::memcache_hosts
  $package_name                   = $::graphite::web::package_name
  $remote_find_cache_duration     = $::graphite::web::remote_find_cache_duration
  $remote_prefetch_data           = $::graphite::web::remote_prefetch_data
  $remote_rendering               = $::graphite::web::remote_rendering
  $remote_render_connect_timeout  = $::graphite::web::remote_render_connect_timeout
  $remote_store_fetch_timeout     = $::graphite::web::remote_store_fetch_timeout
  $remote_store_find_timeout      = $::graphite::web::remote_store_find_timeout
  $remote_store_merge_results     = $::graphite::web::remote_store_merge_results
  $remote_store_retry_delay       = $::graphite::web::remote_store_retry_delay
  $remote_store_use_post          = $::graphite::web::remote_store_use_post
  $rendering_hosts                = $::graphite::web::rendering_hosts
  $rrd_dir                        = $::graphite::web::rrd_dir
  $secret_key                     = $::graphite::web::secret_key
  $storage_dir                    = $::graphite::web::storage_dir
  $time_zone                      = $::graphite::web::time_zone
  $whisper_dir                    = $::graphite::web::whisper_dir
  $use_remote_user_authentication = $::graphite::web::use_remote_user_authentication

  file { $conf_dir:
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  }

  file { "${conf_dir}/dashboard.conf":
    ensure => file,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  }

  ::concat { "${conf_dir}/local_settings.py":
    owner => 0,
    group => 0,
    mode  => '0644',
    warn  => "# !!! Managed by Puppet !!!\n",
  }

  ::concat::fragment { "${conf_dir}/local_settings.py header":
    content => template("${module_name}/local_settings.py.header.erb"),
    order   => '01',
    target  => "${conf_dir}/local_settings.py",
  }

  ::concat::fragment { "${conf_dir}/local_settings.py footer":
    content => template("${module_name}/local_settings.py.footer.erb"),
    order   => '99',
    target  => "${conf_dir}/local_settings.py",
  }

  exec { 'graphite-manage syncdb --noinput':
    path        => $::path,
    refreshonly => true,
  }

  case $http_server {
    'apache': {
      include ::apache::mod::wsgi

      file { "${::apache::confd_dir}/graphite-web.conf":
        ensure => absent,
      }

      $::graphite::web::apache_resources.each |$type,$resources| {
        $resources.each |$instance,$attributes| { # lint:ignore:variable_scope
          Resource[$type] { # lint:ignore:variable_scope
            $instance: *         => $attributes;
            default:   subscribe => Concat["${conf_dir}/local_settings.py"];
          }
        }
      }

      Exec['graphite-manage syncdb --noinput'] {
        user => $::apache::user,
      }
    }
    default: {
    }
  }
}
