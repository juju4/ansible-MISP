require 'serverspec'

# Required by serverspec
set :backend, :exec

misp_rootdir = '/var/www/_MISP/MISP'
misp_virtualenv = '/var/www/_MISP/venv'

describe command("cd #{misp_rootdir}/tests && ./curl_tests.sh `cat /var/www/_MISP/MISP/.ht_key` | tee /tmp/curl_tests.out") do
## FIXME! is it normal first run get 'HTTP/1.1 500 Internal Server Error', second run: 'HTTP/1.1 100 Continue' + 'HTTP/1.1 302 Found'
##	not like https://travis-ci.org/MISP/MISP/jobs/128166085
  its(:stdout) { should match /548847db-060c-4275-a0c7-15bb950d210b/}
  its(:stdout) { should_not match /HTTP\/1.1 500 Internal Server Error/}
  its(:stderr) { should match /diff compare.csv 1.csv/}
  its(:stderr) { should_not match /error/}
  its(:exit_status) { should eq 0 }
  let(:sudo_options) { '-u _misp -H' }
end

## FIXME!
#describe command("cd #{misp_rootdir}/PyMISP && #{misp_virtualenv}/bin/nosetests --with-coverage --cover-package=pymisp tests/test_offline.py 2>&1 | tee /tmp/nosetests.out") do
#  its(:stdout) { should match /TOTAL/}
#  its(:stdout) { should match /OK/}
#  its(:stdout) { should_not match /FAILED/}
#  its(:exit_status) { should eq 0 }
#  let(:sudo_options) { '-u _misp -H' }
#end

describe command("cd #{misp_rootdir}/PyMISP && #{misp_virtualenv}/bin/python tests/test.py | tee /tmp/tests.out") do
  its(:exit_status) { should eq 0 }
  let(:sudo_options) { '-u _misp -H' }
end

#describe command("cd #{misp_rootdir}/PyMISP/examples/events && #{misp_virtualenv}/bin/python ./create_massive_dummy_events.py -l 5 -a 30") do
#  its(:stdout) { should_not match /500 Server Error: Internal Server Error/}
#  its(:exit_status) { should eq 0 }
#  let(:sudo_options) { '-u _misp -H' }
#end
