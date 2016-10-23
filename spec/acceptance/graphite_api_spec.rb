require 'spec_helper_acceptance'

describe 'graphite::api' do

  it 'should work with no errors' do

    pp = <<-EOS
      include ::epel

      class { '::carbon':
        require => Class['::epel'],
      }

      class { '::graphite::api':
        carbon_hosts => [
          {
            'host' => '127.0.0.1',
            'port' => 7002,
          },
        ],
        require      => [
          Class['::epel'],
          Class['::carbon'],
        ],
      }

      package { 'socat':
        ensure => present,
      }
    EOS

    apply_manifest(pp, :catch_failures => true, :future_parser => true)
    apply_manifest(pp, :catch_changes  => true, :future_parser => true)
  end

  describe package('graphite-api') do
    it { should be_installed }
  end

  describe file('/etc/graphite-api.yaml') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end

  describe file('/etc/sysconfig/graphite-api') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end

  describe service('graphite-api') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(8888) do
    it { should be_listening.on('127.0.0.1').with('tcp') }
  end

  # Send a test metric and give it enough time to get written to disk
  describe command('echo "foo.bar 23 $(date +%s)" | socat - TCP4:localhost:2003 && sleep 5s') do
    its(:exit_status) { should eq 0 }
  end

  # Query test metric through render API in JSON format
  describe command('curl -s "http://localhost:8888/render?target=foo.bar&from=-5min&format=json" | python -mjson.tool') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /^\s+23(?:\.0)?,$/ }
  end
end
