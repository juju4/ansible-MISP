require 'serverspec'

# Required by serverspec
set :backend, :exec

describe command("pip3 freeze") do
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

describe command("misp-modules -t") do
  its(:stdout) { should_not match /ERROR/ }
  its(:stdout) { should_not match /WARNING/ }
  let(:sudo_options) { '-u www-data -H' }
end
