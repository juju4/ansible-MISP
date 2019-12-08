require 'serverspec'

# Required by serverspec
set :backend, :exec

## API test: need to retrieve API key???
#curl -i -H "Accept: application/xml" -H "content-type: text/xml" -H "Authorization: ABCDEF" --data "@input/event.xml" -X POST https:///events

curl_args='-sSvLk'
#misp_url = 'http://localhost'
misp_url = 'https://localhost'
misp_rootdir = '/var/www/_MISP/MISP'

## any content in default/pristine db?
describe command("curl #{curl_args} -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Authorization: '`cat #{misp_rootdir}/.ht_key` #{misp_url}/events/xml/download.json") do
#  its(:stdout) { should match /{"request": {/ }
  its(:stdout) { should_not match /<strong>Error: <\/strong>/ }
  its(:stdout) { should_not match /{"name":"Not Found"/ }
#  its(:stdout) { should_not match /Either specify the search terms in the url/ }
end
describe command("curl #{curl_args} -X POST -H 'Accept: application/xml' -H 'Content-Type: application/xml' -H 'Authorization: '`cat #{misp_rootdir}/.ht_key` #{misp_url}/stix/download") do
#  its(:stdout) { should match /<request>/ }
  its(:stdout) { should_not match /<strong>Error: <\/strong>/ }
#  its(:stdout) { should_not match /<name>Not Found<\/name>/ }
end
describe command("curl #{curl_args} -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Authorization: '`cat #{misp_rootdir}/.ht_key` #{misp_url}/stix/download.json") do
#  its(:stdout) { should match /{"request": {/ }
  its(:stdout) { should_not match /<strong>Error: <\/strong>/ }
#  its(:stdout) { should_not match /{"name":"Not Found"/ }
end
describe command("curl #{curl_args} -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Authorization: '`cat #{misp_rootdir}/.ht_key` #{misp_url}/attributes/text/download/md5") do
#  its(:stdout) { should match /{"request": {/ }
  its(:stdout) { should_not match /<strong>Error: <\/strong>/ }
  its(:stdout) { should_not match /{"name":"Not Found"/ }
end

describe command("curl #{curl_args} -X GET -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Authorization: '`cat #{misp_rootdir}/.ht_key` #{misp_url}/sharing_groups/index.json") do
  its(:stdout) { should match /{"response":\[\]}/ }
  its(:stdout) { should_not match /<strong>Error: <\/strong>/ }
  its(:stdout) { should_not match /{"name":"Not Found"/ }
end
describe command("curl #{curl_args} -X GET -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Authorization: '`cat #{misp_rootdir}/.ht_key` #{misp_url}/admin/users") do
  its(:stdout) { should match /"User": {/ }
  its(:stdout) { should match /"id": "1",/ }
  its(:stdout) { should_not match /<strong>Error: <\/strong>/ }
  its(:stdout) { should_not match /{"name":"Not Found"/ }
end
