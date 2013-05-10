name             'ejabberd'
maintainer       'kyle.burton@gmail.com'
maintainer_email 'kyle.burton@gmail.com'
license          'All rights reserved'
description      'Installs/Configures ejabberd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends           "build-essential"
depends           "erlang"

recipe            "ejabberd",         "Installs eJabberd"
recipe            "ejabberd::source", "Installs eJabberd via source package."
