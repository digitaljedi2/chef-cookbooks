include_recipe "build-essential"

ejabber_url = node['ejaberd']['source']['url']
ejabber_pkg_fname = File.basename(ejabber_url)
ejabber_dname = File.basename(ejabber_url, ".tgz")

file_cache_path = Chef::Config[:file_cache_path]

remote_file File.join(file_cache_path, ejabber_pkg_fname) do
  source ejabber_url
  owner "root"
  mode 0644
  checksum node['erlang']['source']['checksum']
  notifies :run, "bash[install-erlang]", :immediately
  action :create_if_missing
end


# TODO: idempotent unarchive ejabberd
# TODO: idempotent configure for ejabberd
# TODO: idempotent build for ejabberd
# TODO: idempotent install for ejabberd

bash "install-erlang" do
  action :none
  cwd     file_cache_path
  code <<-END
test -d #{ejabber_dname} || tar xzvf #{ejabber_pkg_fname}
  END
end
