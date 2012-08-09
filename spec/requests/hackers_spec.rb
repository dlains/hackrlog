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
    
    it 'shows the premium upgrade form' do
      click_link 'Profile'
      page.should have_selector('form', method: 'post', action: edit_hacker_url(hacker.id)) do |form|
        form.should have_selector('input', type: 'text', id: 'card_number')
        form.should have_selector('input', type: 'text', id: 'card_code')
        form.should have_selector('select', id: 'card_month')
        form.should have_selector('select', id: 'card_year')
      end
    end
    
    context 'when user upgrades account' do
      let(:StripeService) { mock('StripeService')}
      let(:customer) { mock('customer') }
      
      before(:each) do
        click_link 'Profile'
        customer.stub('id').and_return('stipe_customer_token')
        StripeService.stub('create_customer').and_return(customer)
        fill_in 'card_number', with: '4242424242424242'
        fill_in 'card_code', with: '123'
        select '12 - December', from: 'card_month'
        select '2027', from: 'card_year'
        click_button 'Submit'
        hacker.subscription.reload
      end
      
      it 'sets the subscription premium flag to true' do
        hacker.subscription.premium_account.should be_true
      end
      
      it 'sets the subscription start date to today' do
        hacker.subscription.premium_start_date.should eq(Date.today)
      end
      
      it 'sets the stripe customer token' do
        hacker.subscription.stripe_customer_token.should_not be_nil
      end
      
      it 'shows the successfully upgraded alert message' do
        page.should have_content('Congratulations, your account has been upgraded to hackrLog() Premium!')
      end
    end
    
    context 'when upgrading account fails' do
      let(:StripeService) { mock('StripeService')}
      
      before(:each) do
        click_link 'Profile'
        StripeService.stub('create_customer').and_return(nil)
        fill_in 'card_number', with: '4242424242424242'
        fill_in 'card_code', with: '123'
        select '12 - December', from: 'card_month'
        select '2027', from: 'card_year'
        click_button 'Submit'
        hacker.subscription.reload
      end
      
      it 'shows the card processing error' do
        page.should have_content('There was a problem processing your credit card.')
      end
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
        let(:hacker) { FactoryGirl.create(:hacker_with_entries, entries_count: 55) }
        let(:StripeService) { mock('StripeService')}
        
        before(:each) do
          hacker.subscription.premium_account = true
          hacker.subscription.premium_start_date = Date.today
          hacker.subscription.stripe_customer_token = 'premium_token'
          hacker.subscription.save!
          StripeService.stub('cancel_customer_subscription')
        end
        
        it 'should remove premium information' do
          check 'cancel'
          fill_in 'cancel_password', with: hacker.password
          click_button 'Cancel'
          hacker.subscription.reload
          hacker.subscription.premium_account.should be_false
          hacker.subscription.premium_start_date.should be_nil
          hacker.should have(:no).errors_on(:base)
        end
      end
    end
  end
end