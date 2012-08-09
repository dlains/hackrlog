require 'spec_helper'

describe 'Entries' do
  
  describe 'EntriesPage' do
    
    context 'when hacker is one entry under the free account limit' do
      let(:hacker) { FactoryGirl.create(:hacker_with_entries, entries_count: Subscription::FREE_ENTRY_LIMIT - 1) }

      before(:each) do
        visit home_url
        fill_in 'email', with: hacker.email
        fill_in 'password', with: hacker.password
        click_button 'Login'
      end

      it 'renders the entry form' do
        page.should have_selector('form', method: 'post', action: entries_url) do |form|
          form.should have_selector('input', type: 'textarea', name: 'entry[content]')
          form.should have_selector('input', type: 'text', name: 'tags')
          form.should have_selector('button', type: 'submit')
          form.should have_selector('button', type: 'reset')
        end
      end
    end
    
    context 'when hacker is at the free account limit' do
      let(:hacker) { FactoryGirl.create(:hacker_with_entries, entries_count: Subscription::FREE_ENTRY_LIMIT) }
      
      before(:each) do
        visit home_url
        fill_in 'email', with: hacker.email
        fill_in 'password', with: hacker.password
        click_button 'Login'
      end
      
      it 'shows the free account limit reached message' do
        page.should have_content("You have reached the entry limit for a free account.")
      end
    end
  end
end