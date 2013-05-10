include_recipe "build-essential"

ejabber_url = node['ejaberd']['source']['url']
ejabber_fname = File.basename(ejabber_url)
ejabber_dname = File.basename(ejabber_url, ".tgz")

remote_file File.join(Chef::Config[:file_cache_path], ejabber_fname) do
  source ejabber_url
  owner "root"
  mode 0644
  checksum node['erlang']['source']['checksum']
  notifies :run, "bash[install-erlang]", :immediately
  action :create_if_missing
end
