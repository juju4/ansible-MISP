require 'serverspec'

# Required by serverspec
set :backend, :exec

describe process("redis-server") do
  it { should be_running }
end

describe service('redis-server'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_enabled }
  it { should be_running }
end
describe service('redis'), :if => os[:family] == 'redhat' && host_inventory['virtualization'][:system] != 'docker' do
  it { should be_enabled }
end
describe service('redis'), :if => os[:family] == 'redhat' do
  it { should be_running }
end
describe port(6379) do
  it { should be_listening.with('tcp') }
end

describe file('/var/log/redis/redis-server.log'), :if => os[:family] == 'debian' do
  its(:size) { should > 0 }
  its(:content) { should match /Configuration loaded/ }
  its(:content) { should_not match /bind: Cannot assign requested address/ }
end
describe file('/var/log/redis/redis-server.log'), :if => os[:family] == 'ubuntu' && os[:release] == '18.04' do
  its(:size) { should > 0 }
  its(:content) { should match /Configuration loaded/ }
  its(:content) { should_not match /bind: Cannot assign requested address/ }
end
describe file('/var/log/redis/redis-server.log'), :if => os[:family] == 'ubuntu'  && os[:release] == '16.04' do
  its(:size) { should > 0 }
  its(:content) { should match /Server started, Redis version/ }
  its(:content) { should match /The server is now ready to accept connections on port/ }
  its(:content) { should_not match /bind: Cannot assign requested address/ }
end
describe file('/var/log/redis/redis.log'), :if => os[:family] == 'redhat' do
  its(:size) { should > 0 }
  its(:content) { should match /Server started, Redis version/ }
  its(:content) { should match /The server is now ready to accept connections on port/ }
  its(:content) { should_not match /bind: Cannot assign requested address/ }
end
