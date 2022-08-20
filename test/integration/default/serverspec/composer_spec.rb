require 'serverspec'

# Required by serverspec
set :backend, :exec

set :path, '/usr/local/bin:$PATH'

misp_rootdir = '/var/www/_MISP/MISP'
misp_virtualenv = '/var/www/_MISP/venv'

describe command("composer show") do
  its(:stdout) { should match /kamisama\/cake-resque/ }
  its(:stdout) { should match /kamisama\/php-resque-ex-scheduler/ }
  its(:stdout) { should match /pear\/console_commandline/ }
  its(:stdout) { should match /pear\/crypt_gpg/ }
  its(:stdout) { should match /psr\/log/ }
  its(:stdout) { should match /sebastian\/version/ }
  its(:stdout) { should_not match /ERROR/ }
#  its(:stdout) { should_not match /WARNING/ }
  let(:sudo_options) { '-u www-data -H' }
end
