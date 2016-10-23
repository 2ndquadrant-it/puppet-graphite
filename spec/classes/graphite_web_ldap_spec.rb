require 'spec_helper'

describe 'graphite::web::ldap' do

  let(:params) do
    {
      :uri           => 'ldap://example.com',
      :search_base   => 'ou=people,dc=example,dc=com',
      :bind_dn       => 'cn=manager,dc=example,dc=com',
      :bind_password => 'secret',
      :search_filter => '(uid=%s)',
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

      context 'without graphite::web class included' do
        it { expect { should compile }.to raise_error(/must include the graphite::web base class/) }
      end

      context 'with graphite::web class included', :compile do
        let(:pre_condition) do
          'include ::apache class { "::graphite::web": secret_key => "abc123" }'
        end

        it { should contain_class('graphite::web::ldap') }
        it { should contain_class('graphite::web::ldap::config') }
        it { should contain_class('graphite::web::ldap::install') }
        it { should contain_class('graphite::web::params') }
        it do
          should contain_concat__fragment('/etc/graphite-web/local_settings.py ldap').with_content(<<-'EOS'.gsub(/^ {10}/, ''))
          USE_LDAP_AUTH = True
          LDAP_URI = 'ldap://example.com'
          LDAP_SEARCH_BASE = 'ou=people,dc=example,dc=com'
          LDAP_BASE_USER = 'cn=manager,dc=example,dc=com'
          LDAP_BASE_PASS = 'secret'
          LDAP_USER_QUERY = '(uid=%s)'
          EOS
        end
        it { should contain_package('python-ldap') }
      end
    end
  end
end
