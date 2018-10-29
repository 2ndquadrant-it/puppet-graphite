#
class graphite::params {

  case $::osfamily {
    'RedHat': {
      $rrd_dir     = '/var/lib/carbon/rrd'
      $whisper_dir = '/var/lib/carbon/whisper'
    }
    'Debian': {
      $rrd_dir     = '/var/lib/graphite/rrd'
      $whisper_dir = '/var/lib/graphite/whisper'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
