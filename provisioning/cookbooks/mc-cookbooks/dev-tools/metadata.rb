name             'dev-tools'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures an assortment of LAMP/Drupal development tools.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
depends          'drush'
depends          'git'
depends          'lamp'
depends          'phpmyadmin'
depends          'rsync'
depends          'vim'
recipe           "dev-extras", "Installs Xdebug"
recipe           "dev-extras::phpmyadmin", "Installs phpMyAdmin"
recipe           "dev-extras::webgrind", "Installs Webgrind"
recipe           "dev-extras::xhprof", "Installs Xhprof"
