source 'https://rubygems.org'

group :development do
  gem 'mina', :require => false
end

# If you installed openssl through brew on OSX, make sure to run this command
# before bundler:
#
#    bundle config build.eventmachine --with-cppflags=-I/usr/local/opt/openssl/include
#
gem 'dotenv'

# Newer mailcatcher versions cannot handle certain unicode characters (see https://github.com/sj26/mailcatcher/issues/201)
# Therefore, we use this version until they fix it
gem 'mailcatcher', :require => false