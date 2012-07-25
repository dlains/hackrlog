require 'spec_helper'

describe Hacker do
  before(:each) do
    @hacker = Hacker.new(email: "new@domain.com", password: "password", password_confirmation: "password")
  end
  
  it 'is valid with valid attributes' do
    @hacker.should be_valid
    @hacker.time_zone.should_not be_nil
    @hacker.enabled.should be_true
    @hacker.password_digest.should_not be_nil
  end
  
  it 'is not valid without an email' do
    @hacker.email = nil
    @hacker.should_not be_valid
  end
  
  it 'is not valid with a duplicate email' do
    other = Hacker.new(email: 'new@domain.com')
    other.should_not be_valid
  end
  
  it 'is not valid without password_confirmation' do
    @hacker.password_confirmation = nil
    @hacker.should_not be_valid
  end

  it 'does not accept sensitive fields in batch assign' do
    params = { hacker: { enabled: false } }
    lambda {@hacker.update_attributes(params[:hacker])}.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    params = { hacker: { auth_token: 'badassignment' } }
    lambda {@hacker.update_attributes(params[:hacker])}.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    params = { hacker: { password_reset_token: 'badassignment' } }
    lambda {@hacker.update_attributes(params[:hacker])}.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    params = { hacker: { stripe_customer_token: 'badassignment' } }
    lambda {@hacker.update_attributes(params[:hacker])}.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end
  
  describe '#to_xml' do
    it 'does not show sensitive data' do
      @hacker.generate_token(:auth_token)
      @hacker.generate_token(:password_reset_token)
      @hacker.generate_token(:stripe_customer_token)
      
      xml = @hacker.to_xml
      
      xml.should_not be_nil
      xml.include?('<pasword_digest>').should be_false
      xml.include?('<auth_token').should be_false
      xml.include?('<password_reset_token>').should be_false
      xml.include?('<password_reset_sent_at>').should be_false
      xml.include?('<premium_start_date>').should be_false
      xml.include?('<premium_active>').should be_false
      xml.include?('<stripe_customer_token>').should be_false 
    end
  end
  
  describe "#send_password_reset" do
    let(:hacker) { FactoryGirl.create(:hacker) }
    
    before do
      hacker.send_password_reset
    end
    
    it "generates a unique password_reset_token each time" do
      last_token = hacker.password_reset_token
      hacker.send_password_reset
      hacker.password_reset_token.should_not eq(last_token)
    end
    
    it "saves the time the password reset was sent" do
      hacker.reload.password_reset_sent_at.should be_present
    end
    
    it "delivers email to user" do
      last_email.to.should include(hacker.email)
    end
  end
  
  describe '#enable_beta_access' do
    let(:hacker) { FactoryGirl.create(:hacker) }
    
    before do
      hacker.enable_beta_access
    end
    
    it 'enables the beta access flag' do
      hacker.beta_access.should be_true
    end
    
    it 'creates a fake password for the hacker' do
      hacker.password_digest.should_not be_nil
    end
    
    it 'delivers beta access request email to the user' do
      last_email.to.should include(hacker.email)
    end
  end
  
  describe '#activate_beta_access' do
    let(:hacker) { FactoryGirl.create(:hacker, beta_access: true) }
    
    before do
      hacker.activate_beta_access
    end
    
    it 'creates a password_reset_token' do
      hacker.password_reset_token.should_not be_nil
    end
    
    it 'delivers the activate beta access email' do
      last_email.to.should include(hacker.email)
    end
  end

  describe "#generate_token" do
    it 'sets a token for the specified field' do
      @hacker.generate_token(:auth_token)
      @hacker.auth_token.should_not be_nil
    end
  end
end