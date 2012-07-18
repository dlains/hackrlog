source 'https://rubygems.org'

gem 'rails', '3.2.6'

gem 'mysql2', :require => 'mysql2'
gem 'redcarpet', :require => 'redcarpet'
gem 'albino', :require => 'albino'
gem 'stripe'

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

group :development do
  gem 'capistrano'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'guard-livereload'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
end

gem 'simplecov', require: false, group: :test

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
