name             'mediawiki'
maintainer       'Terreoets'
maintainer_email 'terrepets@gmail.com'
license          'All rights reserved'
description      'Installs/Configures mediawiki'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends "apache2"
depends "php"
depends "mysql", "4.1.2"
depends "database"
