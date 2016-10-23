require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
  install_puppet
end

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      puppet_module_install(:source => proj_root, :module_name => 'graphite')
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-concat'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-apache'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','bodgit-carbon'),     { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','bodgit-bodgitlib'),  { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','bodgit-memcached'),  { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','bodgit-openldap'),   { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','stahnma-epel'),      { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','arioch-redis'),      { :acceptable_exit_codes => [0,1] }
      scp_to(host, File.join(proj_root, 'spec/fixtures/files/example.ldif'), '/root/example.ldif')
    end
  end
end
