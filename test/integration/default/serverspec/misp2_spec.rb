require 'serverspec'

# Required by serverspec
set :backend, :exec

#describe command('cd /var/www/MISP/tests && ./curl_tests.sh `cat $HOME/build/key.txt`') do
#  its(:stdout) { should match /FIXME/}
#end
#
#describe command('cd /var/www/MISP/PyMISP && coverage run setup.py test') do
#  its(:stdout) { should match /FIXME/ }
#end

