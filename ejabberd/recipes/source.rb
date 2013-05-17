include_recipe "build-essential"

ejabber_url          = node['ejabberd']['source']['url']
ejabber_pkg_fname    = File.basename(ejabber_url)
ejabber_dname        = File.basename(ejabber_url, ".tgz")
ejabber_path         = node['ejabberd']['path']
ejabber_install_path = node['ejabberd']['install_path']

user "ejabberd" do
  action :create
  home ejabber_install_path
  shell "/bin/bash"
end

file_cache_path = Chef::Config[:file_cache_path]
ejabber_remote_file = File.join(file_cache_path, ejabber_pkg_fname) 

bash "install-ejabberd" do
  # NB: run immediately if the file has already been downloaded
  if ::File.exists? ejabber_remote_file
    Chef::Log.info "local file already exists, will register install with action :run"
    action  :run
  else
    Chef::Log.info "local does not already exist, will register install with action :nothing"
    action  :nothing
  end
  cwd     file_cache_path
  code <<-END
date >> #{Chef::Config[:file_cache_path]}/ejabberd.out
if [ -d #{ejabber_dname} ]; then
  echo "archive already extracted" >> #{Chef::Config[:file_cache_path]}/ejabberd.out
else
  tar xzvf #{ejabber_pkg_fname} >> #{Chef::Config[:file_cache_path]}/ejabberd.out
fi

cd #{ejabber_dname}/src || echo "Whoops, #{ejabber_dname}/src doesn't exist?" >> #{Chef::Config[:file_cache_path]}/ejabberd.out
if [ -f Makefile ]; then
  echo "Makefile exists, configure must have been run" >> #{Chef::Config[:file_cache_path]}/ejabberd.out
else
  ./configure --prefix=#{ejabber_install_path} >> #{Chef::Config[:file_cache_path]}/ejabberd.out
fi

if [ -f #{ejabber_install_path}/sbin/ejabberdctl ]; then
  echo "#{ejabber_install_path}/sbin/ejabberdctl exists, install must have been done" >> #{Chef::Config[:file_cache_path]}/ejabberd.out
else
  (make && make install)    >> #{Chef::Config[:file_cache_path]}/ejabberd.out
fi

if [ -h #{ejabber_path} ]; then
  echo "#{ejabber_path} symlink already exists, all done." >> #{Chef::Config[:file_cache_path]}/ejabberd.out
else
  ln -s #{ejabber_install_path} #{ejabber_path} >> #{Chef::Config[:file_cache_path]}/ejabberd.out
fi

chown -R ejabberd.ejabberd #{ejabber_install_path}

  END
end

Chef::Log.info "configuring remote file: #{ejabber_remote_file}"
remote_file ejabber_remote_file do
  source ejabber_url
  owner "root"
  mode 0644
  checksum node['ejabberd']['source']['checksum']
  notifies :run, "bash[install-ejabberd]", :immediately
  action :create_if_missing
end

