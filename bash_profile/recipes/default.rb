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

(node['bash_profile']['users'] || []).each do |user|
  bash "install profile for #{user}" do
    user  user
    group user
    cwd   "/home/#{user}"
    code <<-END
      test -d .profile.d || git clone #{bash_profile_git_url} .profile.d
      # move .bashrc, .vimrc aside if they are not symlinks
      if [ -e .bashrc ]; then
        if [ ! -h .bashrc ]; then
          mv .bashrc .dist.bashrc
        fi
      fi
      cd .profile.d
      date > /tmp/inst.out
      HOME=/home/#{user} bash install.sh kburton 2>&1 | tee -a /tmp/inst.out
    END
  end
end
