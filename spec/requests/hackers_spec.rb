require 'spec_helper'

describe 'Hackers' do
  
  describe 'ProfilePage' do
    let(:hacker) { FactoryGirl.create(:hacker) }
    
    before(:each) do
      visit home_url
      fill_in 'email', with: hacker.email
      fill_in 'password', with: hacker.password
      click_button 'Login'
    end
    
    it 'shows the profile page for authorized users' do
      click_link 'Profile'
      current_path.should eq(edit_hacker_path(hacker.id))
    end
    
    it 'shows the cancel account form' do
      click_link 'Profile'
      page.should have_selector('form', method: 'post', action: cancel_hacker_url(hacker.id)) do |form|
        form.should have_selector('input', type: 'checkbox', id: 'cancel')
        form.should have_selector('input', type: 'password', name: 'cancel_password')
      end
    end
    
    context 'when user cancels account' do
      let(:hacker) { FactoryGirl.create(:hacker_with_entries) }

      before(:each) do
        click_link 'Profile'
      end
      
      it 'sets the hacker to inactive' do
        check 'cancel'
        fill_in 'cancel_password', with: hacker.password
        click_button('Cancel')
        hacker.reload
        hacker.enabled.should be_false
      end
      
      it 'removes associated entries' do
        hacker.entries.length.should eq(5)
        check 'cancel'
        fill_in 'cancel_password', with: hacker.password
        click_button 'Cancel'
        hacker.reload
        hacker.entries.length.should eq(0)
      end
      
      it 'shows an error if the wrong password is provided' do
        check 'cancel'
        fill_in 'cancel_password', with: 'badpassword'
        click_button('Cancel')
        current_path.should eq(edit_hacker_path(hacker.id))
        page.should have_content('Incorrect password supplied')
      end

      it 'sends the account closed email' do
        check 'cancel'
        fill_in 'cancel_password', with: hacker.password
        click_button 'Cancel'
        last_email.to.should include(hacker.email)
      end
      
      it 'redirects to the home page' do
        check 'cancel'
        fill_in 'cancel_password', with: hacker.password
        click_button 'Cancel'
        current_path.should eq(home_path)
      end
      
      context 'with premium enabled' do
        let(:hacker) { FactoryGirl.create(:hacker, premium_active: true, premium_start_date: Time.now, stripe_customer_token: 'premium_token') }
        let(:StripeService) { mock('StripeService')}
        
        before(:each) do
          StripeService.stub('cancel_customer_subscription')
        end
        
        it 'should remove premium information' do
          check 'cancel'
          fill_in 'cancel_password', with: hacker.password
          click_button 'Cancel'
          hacker.reload
          hacker.premium_active.should be_false
          hacker.premium_start_date.should be_nil
          hacker.should have(:no).errors_on(:base)
        end
      end
    end
  end
end