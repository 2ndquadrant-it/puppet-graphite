#
class graphite::api (
  String               $address              = $::graphite::api::params::address,
  Optional[
    Array[String, 1]
  ]                    $allowed_origins      = undef,
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
  ]                    $carbon_hosts         = undef,
  Optional[String]     $carbon_metric_prefix = undef,
  Optional[Integer[0]] $carbon_retry_delay   = undef,
  Optional[Integer[0]] $carbon_timeout       = undef,
  String               $conf_file            = $::graphite::api::params::conf_file,
  String               $group                = $::graphite::api::params::group,
  String               $package_name         = $::graphite::api::params::package_name,
  Integer[0, 65535]    $port                 = $::graphite::api::params::port,
  Optional[Boolean]    $render_errors        = undef,
  Optional[Integer[1]] $replication_factor   = undef,
  String               $service_name         = $::graphite::api::params::service_name,
  String               $state_dir            = $::graphite::api::params::state_dir,
  Optional[String]     $time_zone            = undef,
  String               $user                 = $::graphite::api::params::user,
  String               $whisper_dir          = $::graphite::api::params::whisper_dir,
  Integer[1]           $workers              = $::graphite::api::params::workers,
) inherits ::graphite::api::params {

  validate_absolute_path($conf_file)
  validate_absolute_path($state_dir)
  validate_absolute_path($whisper_dir)

  include ::graphite::api::install
  include ::graphite::api::config
  include ::graphite::api::service

  anchor { 'graphite::api::begin': }
  anchor { 'graphite::api::end': }

  Anchor['graphite::api::begin'] -> Class['::graphite::api::install']
    ~> Class['::graphite::api::config'] ~> Class['::graphite::api::service']
    -> Anchor['graphite::api::end']
}
