require 'spec_helper'

describe 'Sessions' do
  
  describe 'GET login_path' do
    it 'renders the login form' do
      visit login_path
      
      page.should have_selector('input', type: 'email')
      page.should have_selector('input', type: 'password')
      page.should have_selector('input', type: 'checkbox', name: 'remember_me')
      page.should have_selector('input', type: 'submit', name: 'login')
      
      page.should have_content('Reset password?')
    end
  end
  
  describe 'POST login_path' do
    it 'should not log in unknown users' do
      visit login_path
      
      fill_in 'email', with: 'nobody@nodomain.com'
      fill_in 'password', with: 'notagoodpassword'
      
      click_button 'Login'
      
      current_path.should eq(login_path)
      page.should have_content('Invalid email or password combination')
    end
    
    it 'should not log in known users with bad passwords' do
      hacker = FactoryGirl.create(:hacker)
      visit login_path
      
      fill_in 'email', with: hacker.email
      fill_in 'password', with: 'notagoodpassword'
      
      click_button 'Login'
      
      current_path.should eq(login_path)
      page.should have_content('Invalid email or password combination')
    end
    
    it 'should log in known users with correct passwords' do
      hacker = FactoryGirl.create(:hacker)
      visit login_path
      
      fill_in 'email', with: hacker.email
      fill_in 'password', with: hacker.password
      
      click_button 'Login'
      
      current_path.should eq(entries_path)
    end
  end
  
  describe 'GET logout_path' do
    it 'should log the user out' do
      hacker = FactoryGirl.create(:hacker)
      visit login_path
      
      fill_in 'email', with: hacker.email
      fill_in 'password', with: hacker.password
      
      click_button 'Login'
      
      current_path.should eq(entries_path)
      
      click_link 'Sign Out'
      
      current_path.should eq(home_path)
    end
  end
end