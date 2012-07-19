require 'spec_helper'

describe SessionsController do
  
  describe 'POST create' do
    it 'should store a cookie for users auth_token' do
      hacker = FactoryGirl.create(:hacker)
      post :create, { email: hacker.email, password: hacker.password }
      
      response.cookies.should have_key('auth_token')
      response.cookies['auth_token'].should eq(hacker.auth_token)
    end
  end
end      