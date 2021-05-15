require 'serverspec'

# Required by serverspec
set :backend, :exec

#describe process('python') do
#  it { should be_running }
#  its(:args) { should match /manage.py runserver\b/ }
#  it "is listening on port 8000" do
#    expect(port(8000)).to be_listening
#  end
#end

describe command('wget -O - http://localhost') do
  its(:stdout) { should match /Users - MISP/ }
end

## API test: need to retrieve API key???
#curl -i -H "Accept: application/xml" -H "content-type: text/xml" -H "Authorization: ABCDEF" --data "@input/event.xml" -X POST https:///events
#describe command('wget -O - http://localhost/events/xml/download.json') do
#  its(:stdout) { should match /{"request": {/ }
#end
#describe command('wget -O - http://localhost/stix/download') do
#  its(:stdout) { should match /<request>/ }
#end
#describe command('wget -O - http://localhost/stix/download.json') do
#  its(:stdout) { should match /{"request": {/ }
#end
