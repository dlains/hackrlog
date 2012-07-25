require 'spec_helper'

describe BetaRequestsController do

  describe 'GET index' do
    it 'should get the beta request success form' do
      get :index
      response.status.should eq(200)
    end
  end

  describe 'GET new' do
    it 'should get the beta request form' do
      get :new
      response.status.should eq(200)
    end
  end
  
  describe 'POST create' do
    let(:hacker) { mock_model(Hacker).as_null_object }

    before do
      Hacker.stub(:new).and_return(hacker)
      hacker.stub(:enable_beta_access)
    end
    
    it 'creates a new hacker with a generated password' do
      Hacker.should_receive(:new).with('email' => 'test@beta-request.com').and_return(hacker)
      post :create, beta_request: { 'email' => 'test@beta-request.com' }
    end
    
    it 'saves the hacker' do
      hacker.should_receive(:enable_beta_access).once
      hacker.should_receive(:save).once
      post :create
    end
    
    context 'when the message saves successfully' do
      it 'sets a flash[:notice] message' do
        post :create
        flash[:notice].should eq("// Your hackrLog() Beta request has been\n  // recorded. You will get further instrunctions\n  // when the Beta goes live.")
      end

      it 'redirects to the BetaRequests index' do
        post :create
        response.should redirect_to(:action => 'index')
      end
    end
    
    context 'when the message fails to save' do
      before do
        hacker.stub(:save).and_return(false)
      end
      
      it 'sets a flash[:notice] message' do
        post :create
        flash[:notice].should eq("// There was a problem registering that email\n  // address for beta access. Please be\n  // sure you provide a valid email address.")
      end
      
      it 'renders the new template' do
        post :create
        response.should render_template('new')
      end
    end
  end
  
  describe 'GET activate' do
    let(:hacker) { mock_model(Hacker, beta_access: true) }
    
    before do
      Hacker.stub(:find_each).and_yield(hacker)
      hacker.stub(:activate_beta_access)
    end
    
    it 'finds beta access hackers' do
      Hacker.should_receive(:find_each).and_return(hacker)
      get :activate
    end
    
    it 'activates beta access' do
      hacker.should_receive(:activate_beta_access)
      get :activate
    end
  end
      
  describe 'GET edit' do
    before do
      beta_user = FactoryGirl.create(:hacker, beta_access: true, password_reset_token: 'anything')
    end
    
    it 'shows the set password form' do
      get :edit, id: 'anything'
      response.status.should eq(200)
    end
  end
  
  describe 'PUT update' do
    before do
      hacker = FactoryGirl.create(:hacker, beta_access: true, password_reset_token: 'anything')
    end
    
    it 'redirects the beta user to the entries page' do
      put :update, id: 'anything'
      response.status.should eq(302)
    end
  end
end
