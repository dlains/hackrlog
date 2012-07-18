require 'spec_helper'

describe Hacker do
  describe "#send_password_reset" do
    let(:hacker) { FactoryGirl.create(:hacker) }
    
    it "generates a unique password_reset_token each time" do
      hacker.send_password_reset
      last_token = hacker.password_reset_token
      hacker.send_password_reset
      hacker.password_reset_token.should_not eq(last_token)
    end
    
    it "saves the time the password reset was sent" do
      hacker.send_password_reset
      hacker.reload.password_reset_sent_at.should be_present
    end
    
    it "delivers email to user" do
      hacker.send_password_reset
      last_email.to.should include(hacker.email)
    end
  end
end