require 'spec_helper'

describe 'graphite::api::memcached' do

  let(:params) do
    {
      :servers => [
        {
          'host' => '12⒎.0.0.1',
          'port' => 11211,
        },
      ],
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
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'without graphite::api class included' do
        it { expect { should compile }.to raise_error(/must include the graphite::api base class/) }
      end

      context 'with graphite::api class included', :compile do
        let(:pre_condition) do
          'include ::graphite::api'
        end

        it { should contain_class('graphite::api::memcached') }
        it { should contain_class('graphite::api::memcached::config') }
        it { should contain_class('graphite::api::memcached::install') }
        it { should contain_class('graphite::api::params') }
        it do
          should contain_concat__fragment('/etc/graphite-api.yaml cache').with_content(<<-'EOS'.gsub(/^ {10}/, ''))
          cache:
            type: memcached
            memcached_servers:
              - '12⒎.0.0.1:11211'
            default_timeout: 60
            key_prefix: 'graphite-api'
          EOS
        end
      end
    end
  end
end
