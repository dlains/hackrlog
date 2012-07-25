require 'spec_helper'

describe 'beta_requests/activate.html.erb' do
  
  it 'displays the beta activation page' do
    render
    rendered.should have_selector('h2')
    rendered.should have_content('hackrLog() Beta Activation')
    rendered.should have_selector('p')
    rendered.should have_content('All beta users have been sent activation emails.')
  end
end