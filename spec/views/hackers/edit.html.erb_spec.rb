require 'spec_helper'

describe 'hackers/edit.html.erb' do
  
  it 'displays the profile page' do
    assign(:hacker, @hacker = FactoryGirl.create(:hacker))
    
    render
    rendered.should have_selector('div', class: 'tabbable')
    rendered.should have_selector('div', class: 'tab-content')
  end
  
  it 'contains the cancel form' do
    assign(:hacker, @hacker = FactoryGirl.create(:hacker))
    
    render
    rendered.should have_content('If you cancel your account your data will be deleted. If you wish to keep your data please export it first.')
    rendered.should have_selector('form', method: 'delete', action: hacker_url(@hacker.id)) do |form|
      form.should have_selector('input', type: 'checkbox', id: 'cancel')
      form.should have_selector('input', type: 'password', name: 'cancel_password')
    end
  end
end