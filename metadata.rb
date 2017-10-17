name             'dy-citadel'
maintainer       'Dynamic Yield'
maintainer_email 'devops@dynamicyield.com'
license          'Apache-2.0'
description      'DSL for accessing secret data stored on S3 using IAM roles.  Forked from Citadel.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.0'

chef_version '>= 12'

gem 'aws-sdk', '~> 3.0.0'
