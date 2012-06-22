source 'https://rubygems.org'

gem 'rails', '3.2.6'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2', :require => 'mysql2'
gem 'redcarpet', :require => 'redcarpet'
gem 'albino', :require => 'albino'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'therubyracer'
  gem 'execjs'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

gem 'unicorn', '4.3.1'

# Deploy with Capistrano
group :development do
  gem 'capistrano'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'