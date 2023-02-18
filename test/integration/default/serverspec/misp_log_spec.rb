require 'serverspec'

# Required by serverspec
set :backend, :exec

misp_rootdir = '/var/www/_MISP/MISP'

describe file("#{misp_rootdir}/app/tmp/logs/error.log") do
#  its(:size) { should > 0 }
#  its(:content) { should_not match /Error:/ }
  its(:content) { should_not match /Warning:((?!\[snuffleupagus\]).)*/i }
end

#describe file("#{misp_rootdir}/app/tmp/logs/resque-worker-error.log") do
#  its(:size) { should > 0 }
#end
