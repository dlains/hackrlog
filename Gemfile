source 'https://rubygems.org'

gem 'rails', '3.2.6'

gem 'mysql2', :require => 'mysql2'
gem 'redcarpet', :require => 'redcarpet'
gem 'pygments.rb'
gem 'stripe'
gem 'rack-mini-profiler', '<= 0.1.14'
gem 'newrelic_rpm'

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

gem 'unicorn', '4.4.0'

group :development do
  gem 'capistrano'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'spork'
  gem 'guard-spork'
end

gem 'simplecov', require: false, group: :test
gem 'rails_best_practices', require: false, group: :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
