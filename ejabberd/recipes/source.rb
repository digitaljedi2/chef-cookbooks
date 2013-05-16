include_recipe "build-essential"

ejabber_url          = node['ejabberd']['source']['url']
ejabber_pkg_fname    = File.basename(ejabber_url)
ejabber_dname        = File.basename(ejabber_url, ".tgz")
ejabber_path         = node['ejabberd']['path']
ejabber_install_path = node['ejabberd']['install_path']

file_cache_path = Chef::Config[:file_cache_path]
ejabber_remote_file = File.join(file_cache_path, ejabber_pkg_fname) 

bash "install-ejabberd" do
  # NB: run immediately if the file has already been downloaded
  if ::File.exists? ejabber_remote_file
    action  :run
  else
    action  :nothing
  end
  cwd     file_cache_path
  code <<-END
test -d #{ejabber_dname} || tar xzvf #{ejabber_pkg_fname}
cd #{ejabber_dname}/src
test -f Makefile ./configure --prefix=#{ejabber_install_path}
test -f #{ejabber_install_path}/sbin/ejabberdctl make && make install
test -h #{ejabber_path} || ln -s #{ejabber_install_path} #{ejabber_path}
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

