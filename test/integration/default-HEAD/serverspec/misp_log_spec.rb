require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/var/www/MISP/app/tmp/logs/error.log') do
  its(:size) { should > 0 }
#  its(:content) { should_not match /Error:/ }
  its(:content) { should_not match /Warning:/ }
end

#describe file('/var/www/MISP/app/tmp/logs/resque-worker-error.log') do
#  its(:size) { should > 0 }
#end
