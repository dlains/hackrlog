require "spec_helper"

describe Notifier do
  describe "password_reset" do
    let(:hacker) { FactoryGirl.create(:hacker, password_reset_token: 'anything') }
    let(:mail)   { Notifier.password_reset(hacker) }
    
    it "contains user password reset url" do
      mail.subject.should eq("hackrLog() password reset.")
      mail.to.should eq([hacker.email])
      mail.from.should eq(['noreply@hackrlog.com'])
      mail.body.encoded.should match(edit_password_reset_path(hacker.password_reset_token))
    end
  end
  
  describe 'beta_access_request' do
    let(:hacker) { FactoryGirl.create(:hacker) }
    let(:mail)  { Notifier.beta_access_request(hacker) }
    
    it 'contains the beta access request message' do
      mail.subject.should eq('hackrLog() Beta Access Request.')
      mail.to.should eq([hacker.email])
      mail.from.should eq(['noreply@hackrlog.com'])
    end
  end
  
  describe 'activate_beta_access' do
    let(:hacker) { FactoryGirl.create(:hacker, beta_access: true, password_reset_token: 'anything') }
    let(:mail) { Notifier.activate_beta_access(hacker) }
    
    it 'contains the user beta activations url' do
      mail.subject.should eq("hackrLog() Beta Activation.")
      mail.to.should eq([hacker.email])
      mail.from.should eq(['noreply@hackrlog.com'])
      mail.body.encoded.should match(edit_beta_request_path(hacker.password_reset_token))
    end
  end
      
end
