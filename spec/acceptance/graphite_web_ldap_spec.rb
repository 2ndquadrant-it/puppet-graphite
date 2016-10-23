require 'spec_helper_acceptance'

describe 'graphite::web::ldap' do

  it 'should work with no errors' do

    pp = <<-EOS
      include ::epel

      include ::openldap
      include ::openldap::client
      class { '::openldap::server':
        root_dn              => 'cn=Manager,dc=example,dc=com',
        root_password        => 'secret',
        suffix               => 'dc=example,dc=com',
        access               => [
          'to attrs=userPassword by self =xw by anonymous auth',
          'to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage by users read',
        ],
        ldap_interfaces      => ['#{default.ip}'],
        local_ssf            => 256,
      }
      ::openldap::server::schema { 'cosine':
        position => 1,
      }
      ::openldap::server::schema { 'inetorgperson':
        position => 2,
      }
      ::openldap::server::schema { 'nis':
        position => 3,
      }

      class { '::carbon':
        require => Class['::epel'],
      }

      class { '::apache':
        default_confd_files => false,
        default_mods        => false,
        default_vhost       => false,
      }

      class { '::graphite::web':
        secret_key       => 'abc123',
        carbonlink_hosts => [
          {
            'host' => '127.0.0.1',
            'port' => 7002,
          },
        ],
        require          => [
          Class['::epel'],
          Class['::carbon'],
        ],
      }

      class { '::graphite::web::ldap':
        bind_dn       => 'cn=Manager,dc=example,dc=com',
        bind_password => 'secret',
        search_base   => 'dc=example,dc=com',
        search_filter => '(uid=%s)',
        uri           => 'ldap://#{default.ip}',
        require       => Class['::openldap::server'],
      }

      package { 'socat':
        ensure => present,
      }
    EOS

    apply_manifest(pp, :catch_failures => true, :future_parser => true)
    apply_manifest(pp, :catch_changes  => true, :future_parser => true)
  end

  describe command('ldapadd -Y EXTERNAL -H ldapi:/// -f /root/example.ldif') do
    its(:exit_status) { should eq 0 }
  end

  describe package('graphite-web') do
    it { should be_installed }
  end

  describe package('python-ldap') do
    it { should be_installed }
  end

  describe service('httpd') do
    it { should be_enabled }
    it { should be_running }
  end

  # Send a test metric and give it enough time to get written to disk
  describe command('echo "foo.bar 23 $(date +%s)" | socat - TCP4:localhost:2003 && sleep 5s') do
    its(:exit_status) { should eq 0 }
  end

  # Query test metric through render API in JSON format
  describe command('curl -s "http://localhost/render?target=foo.bar&from=-5min&format=json" | python -mjson.tool') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /^\s+23(?:\.0)?,$/ }
  end

  # Mark LDAP user as a superuser
  describe command('graphite-manage createsuperuser --noinput --username=alice --email=alice@example.com') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /^Superuser created successfully\.$/ }
  end

  # FIXME work out how to curl a login test that uses LDAP
end
