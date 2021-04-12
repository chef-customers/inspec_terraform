# copyright: 2018, The Authors

title 'my_profile'

# you add controls here
control 'chef_installed' do
  impact 0.7
  title 'chef_installed'
  desc 'Chef Workstation components should be installed on the system.'
  describe package('chef-workstation') do
    it { should be_installed }
  end
  describe package('some_package_not_installed') do
    it { should be_installed }
  end
end
