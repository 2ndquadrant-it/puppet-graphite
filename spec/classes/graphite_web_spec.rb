require 'spec_helper'

describe 'graphite::web' do

  let(:params) do
    {
      :secret_key                    => 'abc123',
      :allowed_hosts                 => ['*'],
      :time_zone                     => 'Europe/London',
      :documentation_url             => 'http://graphite.readthedocs.org/',
      :log_rendering_performance     => true,
      :log_cache_performance         => true,
      :log_metric_access             => true,
      :debug                         => true,
      :flushrrdcached                => 'unix:/var/run/rrdcached.sock',
      :memcache_hosts                => [
        {
          'host' => '10.10.10.10',
          'port' => 11211,
        },
      ],
      :default_cache_duration        => 60,
      :cluster_servers               => [
        {
          'host' => '10.0.2.2',
        },
        {
          'host' => '10.0.2.3',
          'port' => 80,
        },
      ],
      :remote_store_fetch_timeout    => 6,
      :remote_store_find_timeout     => 2.5,
      :remote_store_retry_delay      => 60,
      :remote_store_use_post         => false,
      :remote_find_cache_duration    => 300,
      :remote_prefetch_data          => false,
      :remote_store_merge_results    => true,
      :remote_rendering              => true,
      :rendering_hosts               => [
        {
          'host' => '10.0.2.2',
        },
        {
          'host' => '10.0.2.3',
          'port' => 80,
        },
      ],
      :remote_render_connect_timeout => 1.0,
      :carbonlink_hosts              => [
        {
          'host'     => '127.0.0.1',
          'port'     => 7002,
          'instance' => 'a',
        },
        {
          'host'     => '127.0.0.1',
          'port'     => 7102,
          'instance' => 'b',
        },
        {
          'host'     => '127.0.0.1',
          'port'     => 7202,
          'instance' => 'c',
        },
      ],
      :carbonlink_timeout            => 1.0,
      :carbonlink_query_bulk         => true,
    }
  end

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it { expect { should compile }.to raise_error(/not supported on an Unsupported/) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts
      end

      let(:pre_condition) do
        'include ::apache'
      end

      it { should contain_anchor('graphite::web::begin') }
      it { should contain_anchor('graphite::web::end') }
      it { should contain_apache__vhost('graphite-web') }
      it { should contain_class('graphite::params') }
      it { should contain_class('graphite::web') }
      it { should contain_class('graphite::web::config') }
      it { should contain_class('graphite::web::install') }
      it { should contain_class('graphite::web::params') }
      it { should contain_concat('/etc/graphite-web/local_settings.py') }
      it do
        should contain_concat__fragment('/etc/graphite-web/local_settings.py header').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        SECRET_KEY = 'abc123'
        ALLOWED_HOSTS = ['*']
        TIME_ZONE = 'Europe/London'
        DOCUMENTATION_URL = 'http://graphite.readthedocs.org/'
        LOG_RENDERING_PERFORMANCE = True
        LOG_CACHE_PERFORMANCE = True
        LOG_METRIC_ACCESS = True
        DEBUG = True
        FLUSHRRDCACHED = 'unix:/var/run/rrdcached.sock'
        MEMCACHE_HOSTS = ['10.10.10.10:11211']
        DEFAULT_CACHE_DURATION = 60
        GRAPHITE_ROOT = '/usr/share/graphite'
        CONF_DIR = '/etc/graphite-web'
        STORAGE_DIR = '/var/lib/graphite-web'
        CONTENT_DIR = '/usr/share/graphite/webapp/content'
        DASHBOARD_CONF = '/etc/graphite-web/dashboard.conf'
        GRAPHTEMPLATES_CONF = '/etc/graphite-web/graphTemplates.conf'
        WHISPER_DIR = '/var/lib/carbon/whisper'
        RRD_DIR = '/var/lib/carbon/rrd'
        DATA_DIRS = [WHISPER_DIR, RRD_DIR]
        LOG_DIR = '/var/log/graphite-web'
        INDEX_FILE = '/var/lib/graphite-web/index'
        EOS
      end
      it do
        should contain_concat__fragment('/etc/graphite-web/local_settings.py footer').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        DATABASES = {
          'default': {
            'NAME': '/var/lib/graphite-web/graphite.db',
            'ENGINE': 'django.db.backends.sqlite3',
            'USER': '',
            'PASSWORD': '',
            'HOST': '',
            'PORT': ''
          }
        }
        CLUSTER_SERVERS = ['10.0.2.2', '10.0.2.3:80']
        REMOTE_STORE_FETCH_TIMEOUT = 6
        REMOTE_STORE_FIND_TIMEOUT = 2.5
        REMOTE_STORE_RETRY_DELAY = 60
        REMOTE_STORE_USE_POST = False
        REMOTE_FIND_CACHE_DURATION = 300
        REMOTE_PREFETCH_DATA = False
        REMOTE_STORE_MERGE_RESULTS = True
        REMOTE_RENDERING = True
        RENDERING_HOSTS = ['10.0.2.2', '10.0.2.3:80']
        REMOTE_RENDER_CONNECT_TIMEOUT = 1.0
        CARBONLINK_HOSTS = ['127.0.0.1:7002:a', '127.0.0.1:7102:b', '127.0.0.1:7202:c']
        CARBONLINK_TIMEOUT = 1.0
        CARBONLINK_QUERY_BULK = True
        EOS
      end
      it { should contain_exec('graphite-manage syncdb --noinput') }
      it { should contain_file('/etc/graphite-web') }
      it { should contain_file('/etc/graphite-web/dashboard.conf') }
      it { should contain_package('graphite-web') }
    end
  end
end
