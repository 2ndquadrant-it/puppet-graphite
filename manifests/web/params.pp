#
class graphite::web::params inherits ::graphite::params {

  case $::osfamily {
    'RedHat': {
      $conf_dir          = '/etc/graphite-web'
      $graphite_root     = '/usr/share/graphite'
      $http_server       = 'apache'
      $ldap_package_name = 'python-ldap'
      $log_dir           = '/var/log/graphite-web'
      $package_name      = 'graphite-web'
      $rrd_dir           = $::graphite::params::rrd_dir
      $storage_dir       = '/var/lib/graphite-web'
      $databases         = {
        'default' => {
          'name'   => "${storage_dir}/graphite.db",
          'engine' => 'django.db.backends.sqlite3',
        },
      }
      $apache_resources  = {
        '::apache::vhost' => {
          'graphite-web' => {
            'access_log'                 => true,
            'access_log_file'            => 'graphite-web-access.log',
            'access_log_format'          => 'common',
            'aliases'                    => [
              {
                'alias' => '/media/',
                'path'  => '/usr/lib/python2.7/site-packages/django/contrib/admin/media/',
              },
            ],
            'directories'                => [
              {
                'path'       => '/content/',
                'provider'   => 'location',
                'sethandler' => 'None',
              },
              {
                'path'       => '/media/',
                'provider'   => 'location',
                'sethandler' => 'None',
              },
              {
                'path'     => $graphite_root,
                'provider' => 'directory',
                'require'  => 'local',
              },
            ],
            'docroot'                    => "${graphite_root}/webapp",
            'error_log'                  => true,
            'error_log_file'             => 'graphite-web-error.log',
            'port'                       => 80,
            'wsgi_import_script'         => "${graphite_root}/graphite-web.wsgi",
            'wsgi_import_script_options' => {
              'process-group'     => '%{GLOBAL}',
              'application-group' => '%{GLOBAL}',
            },
            'wsgi_script_aliases'        => {
              '/' => "${graphite_root}/graphite-web.wsgi",
            },
          },
        },
      }
      $whisper_dir       = $::graphite::params::whisper_dir
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
