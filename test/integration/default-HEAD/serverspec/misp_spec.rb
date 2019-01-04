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

curl_args='-sSvLk'
#misp_url = 'http://localhost'
misp_url = 'https://localhost'

describe command("curl #{curl_args} #{misp_url}") do
  its(:stdout) { should match /Users - MISP/ }
end

