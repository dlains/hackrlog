require "spec_helper"

describe Notifier do
  describe "password_reset" do
    let(:hacker) { FactoryGirl.create(:hacker, password_reset_token: 'anything') }
    let(:mail)   { Notifier.password_reset(hacker) }
    
    it "contains user password reset url" do
      mail.subject.should eq("hackrLog password reset.")
      mail.to.should eq([hacker.email])
      mail.from.should eq(['noreply@hackrlog.com'])
      mail.body.encoded.should match(edit_password_reset_path(hacker.password_reset_token))
    end
  end
end
