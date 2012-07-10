ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_as(hacker)
    cookies[:auth_token] = hackers(hacker).auth_token
  end
  
  def logout
    cookies.delete :auth_token
  end
  
  def setup
    login_as :dave if defined? session
  end
  
  # Enable the Rails logger in our unit tests. Handy for sometimes checking
  # the output that is causing test failures.
  def logger
    ::Rails.logger
  end
  
end
