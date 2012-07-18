require 'spec_helper'

describe "PasswordResets" do
  it "emails user when requesting password reset" do
    hacker = FactoryGirl.create(:hacker)
    visit login_path
    click_link "Reset password?"
    fill_in 'reset_email', :with => hacker.email
    click_button "Reset"
    current_path.should eq(login_path)
    page.should have_content("Email sent")
    last_email.to.should include(hacker.email)
  end

  it "does not email invalid user when requesting password reset" do
    hacker = FactoryGirl.create(:hacker)
    visit login_path
    click_link "Reset password?"
    fill_in 'reset_email', :with => 'notauser@nobody.com'
    click_button "Reset"
    current_path.should eq(new_password_reset_path)
    page.should have_content("Invalid Email")
    last_email.should be_nil
  end
end
