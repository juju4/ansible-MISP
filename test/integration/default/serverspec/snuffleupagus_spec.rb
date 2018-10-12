require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/var/log/apache2/misp.local_error.log') do
  its(:content) { should_not match /PHP Fatal error:/ }
  its(:content) { should_not match /PHP Fatal error:  \[snuffleupagus\]\[config\] Invalid configuration file/ }
end
