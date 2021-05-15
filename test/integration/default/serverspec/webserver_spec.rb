#require 'spec_helper'
require 'serverspec'

# Required by serverspec
set :backend, :exec

describe package('httpd'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('httpd'), :if => os[:family] == 'redhat' && host_inventory['virtualization'][:system] != 'docker' do
  it { should be_enabled }
end
describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_running }
end

describe service('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe service('org.apache.httpd'), :if => os[:family] == 'darwin' do
  it { should be_enabled }
  it { should be_running }
end

describe port(443) do
  it { should be_listening }
end

describe file('/var/log/audit/audit.log'), :if => os[:family] == 'redhat' do
#  its(:size) { should > 0 }
  its(:content) { should_not match /denied  { write } for .* comm="httpd" / }
end
