require 'spec_helper'

describe 'beta_requests/new.html.erb' do
  
  it 'displays the beta request page' do
    render
    rendered.should have_selector('input', type: 'text')
    rendered.should have_selector('input', type: 'submit', value: 'Request Beta Access')
  end
  
  it 'renders a form to request beta access' do
    render
    rendered.should have_selector('form', method: 'post', action: beta_requests_path) do |form|
      form.should have_selector('input', type: 'text', name: 'email', value: '')
      form.should have_selector('input', type: 'submit', value: 'Request Beta Access')
    end
  end
end