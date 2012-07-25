require 'spec_helper'

describe 'beta_requests/edit.html.erb' do
  
  it 'displays the beta login page' do
    assign(:hacker, @hacker = FactoryGirl.create(:hacker, password_reset_token: 'anything'))
    
    render
    rendered.should have_selector('form', method: 'put')
    rendered.should have_selector('input', type: 'password')
    rendered.should have_selector('input', type: 'submit')
  end
end