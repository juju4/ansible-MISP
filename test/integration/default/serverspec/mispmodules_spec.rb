require 'serverspec'

# Required by serverspec
set :backend, :exec

set :path, '/usr/local/bin:$PATH'

misp_rootdir = '/var/www/_MISP/MISP'
misp_virtualenv = '/var/www/_MISP/venv'

describe command("#{misp_virtualenv}/bin/pip freeze") do
  its(:stdout) { should match /cybox/ }
  its(:stdout) { should match /pymisp/ }
  its(:stdout) { should match /stix/ }
end

## any content in default/pristine db?
describe command("curl -s http://127.0.0.1:6666/modules | jq .") do
  its(:stdout) { should_not match /"name": "passivetotal",/ }
  its(:stdout) { should_not match /<strong>Error: <\/strong>/ }
  its(:stdout) { should_not match /{"name":"Not Found"/ }
end

describe command("#{misp_virtualenv}/bin/python -c 'import yara'"), :if => os[:family] == 'ubuntu' && os[:release] != '22.04' do
  its(:stderr) { should_not match /Error/ }
  its(:stderr) { should_not match /Failed/ }
  its(:exit_status) { should eq 0 }
end

describe command("#{misp_virtualenv}/bin/python -c 'import sigma'"), :if => os[:family] == 'ubuntu' && os[:release] != '22.04' do
  its(:stderr) { should_not match /Error/ }
  its(:stderr) { should_not match /Failed/ }
  its(:exit_status) { should eq 0 }
end

describe command("#{misp_virtualenv}/bin/python -c 'import yara'"), :if => os[:family] == 'redhat' && os[:release] == '7' do
  its(:stderr) { should_not match /Error/ }
  its(:stderr) { should_not match /Failed/ }
  its(:exit_status) { should eq 0 }
end

describe command("#{misp_virtualenv}/bin/python -c 'import sigma'"), :if => os[:family] == 'redhat' && os[:release] == '7' do
  its(:stderr) { should_not match /Error/ }
  its(:stderr) { should_not match /Failed/ }
  its(:exit_status) { should eq 0 }
end

describe command("#{misp_virtualenv}/bin/misp-modules -t"), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
  its(:stdout) { should_not match /ERROR/ }
#  its(:stdout) { should_not match /WARNING/ }
  let(:sudo_options) { '-u www-data -H' }
end

describe command("#{misp_virtualenv}/bin/misp-modules -t"), :if => os[:family] == 'ubuntu' && os[:release] == '18.04' do
  its(:stdout) { should_not match /ERROR/ }
#  its(:stdout) { should_not match /WARNING/ }
  let(:sudo_options) { '-u www-data -H' }
end

describe command("#{misp_virtualenv}/bin/misp-modules -t"), :if => os[:family] == 'redhat' && os[:release] == '7' do
  let(:pre_command) { 'export LANG=C LC_ALL=C' }
  its(:stdout) { should_not match /ERROR/ }
  its(:stdout) { should_not match /WARNING/ }
  let(:sudo_options) { '-u www-data -H' }
end

describe command("#{misp_virtualenv}/bin/misp-modules -t"), :if => os[:family] == 'redhat' && os[:release] == '8' do
  let(:pre_command) { 'export LANG=C LC_ALL=C' }
  its(:stdout) { should_not match /ERROR/ }
#  its(:stdout) { should_not match /WARNING/ }
  let(:sudo_options) { '-u www-data -H' }
end
