require 'spec_helper'

describe 'graphite::api::redis' do

  let(:params) do
    {
      :host     => '127.0.0.1',
      :password => 'secret',
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

        it { should contain_class('graphite::api::params') }
        it { should contain_class('graphite::api::redis') }
        it { should contain_class('graphite::api::redis::config') }
        it { should contain_class('graphite::api::redis::install') }
        it do
          should contain_concat__fragment('/etc/graphite-api.yaml cache').with_content(<<-'EOS'.gsub(/^ {10}/, ''))
          cache:
            type: redis
            redis_host: 127.0.0.1
            redis_port: 6379
            redis_password: secret
            redis_db: 0
            default_timeout: 60
            key_prefix: 'graphite-api'
          EOS
        end
        it { should contain_package('python-redis') }
      end
    end
  end
end
