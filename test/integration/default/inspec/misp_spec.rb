
title 'Misp web root check'

curl_args='-sSvLk'
#misp_url = 'http://localhost'
misp_url = 'https://localhost'

control 'misp-1.0' do
  impact 0.7
  title 'Web root page should be available'
  desc 'Ensure web root page is available and responding'

  describe command("curl #{curl_args} #{misp_url}") do
    its(:stdout) { should match /Users - MISP/ }
  end

end
