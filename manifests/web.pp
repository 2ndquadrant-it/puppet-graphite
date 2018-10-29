#
class graphite::web (
  String               $secret_key,
  Optional[
    Array[String, 1]
  ]                    $allowed_hosts                  = undef,
  Hash[String, Hash]   $apache_resources               = $::graphite::web::params::apache_resources,
  Optional[
    Array[
      Struct[
        {
          'host'               => String,
          'port'               => Integer[0, 65535],
          Optional['instance'] => Pattern['\A[a-z]\Z'],
        }
      ],
      1
    ]
  ]                    $carbonlink_hosts               = undef,
  Optional[Boolean]    $carbonlink_query_bulk          = undef,
  Optional[
    Variant[
      Float[0],
      Integer[0]
    ]
  ]                    $carbonlink_timeout             = undef,
  Optional[
    Array[
      Struct[
        {
          'host'           => String,
          Optional['port'] => Integer[0, 65535],
        }
      ],
      1
    ]
  ]                    $cluster_servers                = undef,
  String               $conf_dir                       = $::graphite::web::params::conf_dir,
  Struct[
    {
      'default' => Struct[
        {
          'name'               => String,
          'engine'             => String,
          Optional['user']     => String,
          Optional['password'] => String,
          Optional['host']     => String,
          Optional['port']     => Integer[0, 65535],
        }
      ],
    }
  ]                    $databases                      = $::graphite::web::params::databases,
  Optional[Boolean]    $debug                          = undef,
  Optional[Integer[0]] $default_cache_duration         = undef,
  Optional[String]     $documentation_url              = undef,
  Optional[String]     $flushrrdcached                 = undef,
  String               $graphite_root                  = $::graphite::web::params::graphite_root,
  Enum['apache']       $http_server                    = $::graphite::web::params::http_server,
  Optional[Boolean]    $log_cache_performance          = undef,
  String               $log_dir                        = $::graphite::web::params::log_dir,
  Optional[Boolean]    $log_metric_access              = undef,
  Optional[Boolean]    $log_rendering_performance      = undef,
  Optional[
    Array[
      Struct[
        {
          'host' => String,
          'port' => Integer[0, 65535],
        }
      ]
    ]
  ]                    $memcache_hosts                 = undef,
  String               $package_name                   = $::graphite::web::params::package_name,
  Optional[Integer[0]] $remote_find_cache_duration     = undef,
  Optional[Boolean]    $remote_prefetch_data           = undef,
  Optional[Boolean]    $remote_rendering               = undef,
  Optional[
    Variant[
      Float[0],
      Integer[0]
    ]
  ]                    $remote_render_connect_timeout  = undef,
  Optional[
    Variant[
      Float[0],
      Integer[0]
    ]
  ]                    $remote_store_fetch_timeout     = undef,
  Optional[
    Variant[
      Float[0],
      Integer[0]
    ]
  ]                    $remote_store_find_timeout      = undef,
  Optional[Boolean]    $remote_store_merge_results     = undef,
  Optional[Integer[0]] $remote_store_retry_delay       = undef,
  Optional[Boolean]    $remote_store_use_post          = undef,
  Optional[
    Array[
      Struct[
        {
          'host'           => String,
          Optional['port'] => Integer[0, 65535],
        }
      ],
      1
    ]
  ]                    $rendering_hosts                = undef,
  String               $rrd_dir                        = $::graphite::web::params::rrd_dir,
  String               $storage_dir                    = $::graphite::web::params::storage_dir,
  Optional[String]     $time_zone                      = undef,
  String               $whisper_dir                    = $::graphite::web::params::whisper_dir,
  Optional[Boolean]    $use_remote_user_authentication = undef,
) inherits ::graphite::web::params {

  validate_absolute_path($conf_dir)
  validate_absolute_path($graphite_root)
  validate_absolute_path($log_dir)
  validate_absolute_path($rrd_dir)
  validate_absolute_path($storage_dir)
  validate_absolute_path($whisper_dir)

  include ::graphite::web::install
  include ::graphite::web::config

  anchor { 'graphite::web::begin': }
  anchor { 'graphite::web::end': }

  Anchor['graphite::web::begin'] -> Class['::graphite::web::install']
    ~> Class['::graphite::web::config'] -> Anchor['graphite::web::end']
}
