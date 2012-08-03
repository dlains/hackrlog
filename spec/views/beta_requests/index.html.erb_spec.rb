require 'spec_helper'

describe 'beta_requests/index.html.erb' do
  before do
    flash[:notice] = 'Your hackrLog() Beta request has been recorded. You will get further instrunctions when the Beta goes live.'
  end
  
  it 'displays the beta request acknowledged page' do
    render
    rendered.should have_content('Your hackrLog() Beta request has been recorded. You will get further instrunctions when the Beta goes live.')
  end
  
  it 'should not show a form' do
    render
    rendered.should_not have_selector('form', method: 'post', action: beta_requests_path)
  end
end