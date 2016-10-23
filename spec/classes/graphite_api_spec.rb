require 'spec_helper'

describe 'graphite::api' do

  let(:params) do
    {
      :allowed_origins      => ['*'],
      :carbon_hosts         => [
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
      :carbon_metric_prefix => 'carbon',
      :carbon_retry_delay   => 15,
      :carbon_timeout       => 1,
      :render_errors        => true,
      :replication_factor   => 1,
      :time_zone            => 'UTC',
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

      it { should contain_anchor('graphite::api::begin') }
      it { should contain_anchor('graphite::api::end') }
      it { should contain_class('graphite::api') }
      it { should contain_class('graphite::api::config') }
      it { should contain_class('graphite::api::install') }
      it { should contain_class('graphite::api::params') }
      it { should contain_class('graphite::api::service') }
      it { should contain_class('graphite::params') }
      it { should contain_concat('/etc/graphite-api.yaml') }
      it do
        should contain_concat__fragment('/etc/graphite-api.yaml header').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        ---
        search_index: /var/lib/graphite-api/index
        finders:
          - graphite_api.finders.whisper.WhisperFinder
        functions:
          - graphite_api.functions.SeriesFunctions
          - graphite_api.functions.PieFunctions
        whisper:
          directories:
            - /var/lib/carbon/whisper
        time_zone: UTC
        carbon:
          hosts:
            - 127.0.0.1:7002:a
            - 127.0.0.1:7102:b
            - 127.0.0.1:7202:c
          timeout: 1
          retry_delay: 15
          carbon_prefix: carbon
          replication_factor: 1
        allowed_origins:
          - *
        EOS
      end
      it do
        should contain_concat__fragment('/etc/graphite-api.yaml footer').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        render_errors: True
        EOS
      end
      it do
        should contain_file('/etc/sysconfig/graphite-api').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        # !!! Managed by Puppet !!!
        GRAPHITE_API_ADDRESS=127.0.0.1
        GRAPHITE_API_PORT=8888
        GUNICORN_WORKERS=4
        EOS
      end
      it { should contain_file('/var/lib/graphite-api') }
      it { should contain_group('graphite-api') }
      it { should contain_package('graphite-api') }
      it { should contain_service('graphite-api') }
      it { should contain_user('graphite-api') }
    end
  end
end
