source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'pg'

gem 'blacklight'
gem 'devise'
gem 'jettywrapper'
gem 'nokogiri'

platforms :ruby do
  gem 'therubyracer'
end
platforms :jruby do
  gem 'therubyrhino'
end



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'carrot'

# Use unicorn as the web server (unless it's jruby)
platforms :ruby do
  gem 'unicorn'
end

# http://blog.wyeworks.com/2011/11/1/ruby-1-9-3-and-ruby-debug
#https://gist.github.com/1331533
#gem install ~/Downloads/linecache19-0.5.13.gem
#gem install ~/Downloads/ruby-debug-base19-0.11.26.gem -- --with-ruby-include=/Users/justin/.rvm/rubies/ruby-1.9.3-p0/include/ruby-1.9.1/ruby-1.9.3-p0/
# To use debugger
#gem "linecache19", "0.5.13"
#gem "ruby-debug-base19", "0.11.26"
#gem 'ruby-debug19', :require => 'ruby-debug'

group :development, :test do
  # Pretty printed test output
  gem 'turn', '~> 0.8.3', :require => false
  gem 'rspec-rails'
end

