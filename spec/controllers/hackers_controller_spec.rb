require 'spec_helper'

describe HackersController do
  let(:hacker) { FactoryGirl.create(:hacker) }
  
  before(:each) do
    request.cookies['auth_token'] = hacker.auth_token
  end
  
  
  describe 'GET index' do
    it 'should redirect to the entries page' do
      get :index
      response.should redirect_to(entries_path)
    end
  end
  
  describe 'GET show' do
    it 'should redirect to the entries page' do
      get :show, id: hacker.id
      response.should redirect_to(entries_path)
    end
  end
end