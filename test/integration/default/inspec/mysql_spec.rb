
title 'Misp mysql check'

control 'misp-mysql-1.0' do
  impact 0.7
  title 'MySQL configuration'
  desc 'Ensure MySQL is configured for MISP'

  describe package('mariadb-server'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_installed }
  end

  describe package('mysql-server'), :if => os[:family] == 'redhat' && os[:release] == '6' do
    it { should be_installed }
  end

  describe package('mysql-server'), :if => os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe service('mariadb'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_enabled }
    it { should be_running }
  end
  describe service('mysqld'), :if => os[:family] == 'redhat' && os[:release] == '6' do
    it { should be_enabled }
    it { should be_running }
  end

  #describe service('mysql-server'), :if => os[:family] == 'ubuntu' do
  #  it { should be_enabled }
  #  it { should be_running }
  #end

  #describe service('org.apache.httpd'), :if => os[:family] == 'darwin' do
  #  it { should be_enabled }
  #  it { should be_running }
  #end

  describe port(3306) do
    it { should be_listening }
  end

end
