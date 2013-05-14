#
# Cookbook Name:: bash_profile
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# TODO: for each user in the configuraiton, clone from git and run the installer
# TODO: move aside any existing .bashrc, .vimrc, etc.

bash_profile_git_url = node['bash_profile']['git']['url']

node['bash_profile']['users'].each do |user|
  bash "install profile for #{user}" do
    user user
    group user
    cwd   "/home/#{user}"
    code <<-END
      # move .bashrc, .vimrc aside if they are not symlinks
      test -d .profile.d || git clone #{bash_profile_git_url} .profile.d
    END
  end
end
