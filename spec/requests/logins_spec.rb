require 'spec_helper'

describe "Logins" do
  
  it "redirects to the entries page when a hacker successfully logs in" do
    hacker = FactoryGirl.create(:hacker)
    visit home_url
    fill_in 'email', with: hacker.email
    fill_in 'password', with: hacker.password
    click_button 'Login'
    current_path.should eq(entries_path)
  end

end
