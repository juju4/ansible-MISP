require 'serverspec'

# Required by serverspec
set :backend, :exec

describe command('cd /var/www/MISP/tests && ./curl_tests.sh `cat $HOME/build/key.txt`') do
## FIXME! is it normal first run get 'HTTP/1.1 500 Internal Server Error', second run: 'HTTP/1.1 100 Continue' + 'HTTP/1.1 302 Found'
##	not like https://travis-ci.org/MISP/MISP/jobs/128166085
  its(:stdout) { should match /548847db-060c-4275-a0c7-15bb950d210b/}
  its(:stdout) { should_not match /HTTP\/1.1 500 Internal Server Error/}
  its(:exit_status) { should eq 0 }
  let(:sudo_options) { '-u vagrant -H' }
end

describe command('cd /var/www/MISP/PyMISP && coverage run setup.py test') do
## FIXME! AttributeError: 'module' object has no attribute 'test'
  its(:stdout) { should match /test_create_event/ }
  its(:exit_status) { should eq 0 }
  let(:sudo_options) { '-u vagrant -H' }
end

