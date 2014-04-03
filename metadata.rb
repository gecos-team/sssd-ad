name             'sssd_ad'
maintainer       'Alfredo Matas - Emergya S.L.'
maintainer_email 'amatas@emergya.com'
license          'Apache 2.0'
description      'Installs/Configures AD using SSSD'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

%w{ ubuntu }.each do |os|
  supports os
end
