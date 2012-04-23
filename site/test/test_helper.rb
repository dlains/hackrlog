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
    session[:hacker_id] = hackers(hacker).id
  end
  
  def logout
    session.delete :hacker_id
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
