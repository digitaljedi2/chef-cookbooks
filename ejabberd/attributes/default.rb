default['ejabberd']['version']['major'] = '2'
default['ejabberd']['version']['minor'] = '1'
default['ejabberd']['version']['incremental'] = '12'

default["ejabberd"]["path"] = '/usr/local/ejabberd'
default["ejabberd"]["install_path"]   = [
  '/usr/local/ejabberd-',
  default['ejabberd']['version']['major'],
  ".",
  default['ejabberd']['version']['minor'],
  ".",
  default['ejabberd']['version']['incremental'],
].join('')

# NB: I created the sha1 manually after I downloaded 2.1.12, no checksum
# files seemed to be available at the process-one.net website
default['ejabberd']['source']['checksum'] = "5610a944afb8ac07e68ca87d14ef398a0d42d633"
default['ejabberd']['source']['url'] = [
  "http://www.process-one.net/downloads/ejabberd/",
  default['ejabberd']['version']['major'],
  ".",
  default['ejabberd']['version']['minor'],
  ".",
  default['ejabberd']['version']['incremental'],
  "/ejabberd-",
  default['ejabberd']['version']['major'],
  ".",
  default['ejabberd']['version']['minor'],
  ".",
  default['ejabberd']['version']['incremental'],
  ".tgz"
].join('')


default["ejabberd"]["install_method"] = 'source'
