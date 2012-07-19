require 'spec_helper'

describe 'Home' do
  
  describe 'GET root' do
    it 'gets the home page' do
      visit home_url

      # Check the navigation links.
      page.should have_selector("ul.nav")
      page.should have_selector("a", href: home_about_path)
      page.should have_selector("a", href: home_help_path)
      page.should have_selector("a", href: home_pricing_path)

      # Check the body content.
      # TODO: Fill this in when the home page is nearly done.
      page.should have_selector('div', class: 'hero-unit')
      page.should have_selector('a', class: 'btn',)
      page.should have_content("Sign Up!")
    end
    
    it 'has a login form' do
      visit home_url
      
      # Check for the nav-bar login form.
      page.should have_selector("input", type: 'email')
      page.should have_selector("input", type: 'password')
      page.should have_selector("input", type: 'checkbox', name: 'remember_me')
      page.should have_selector("input", type: 'submit')
    end
  end
  
  describe 'GET about_path' do
    it 'gets the about page' do
      visit home_url
      click_link 'About'
      
      page.should have_selector('ul.nav')
      page.should have_selector('li', class: 'active')
      page.should have_selector('a', href: home_about_path)
    end
  end
  
  describe 'GET help_path' do
    it 'gets the help page' do
      visit home_url
      click_link 'Help'
      
      page.should have_selector('ul.nav')
      page.should have_selector('li', class: 'active')
      page.should have_selector('a', href: home_help_path)
    end
  end
  
  describe 'GET pricing_path' do
    it 'gets the pricing page' do

      visit home_url
      click_link 'Pricing'
      
      page.should have_selector('ul.nav')
      page.should have_selector('li', class: 'active')
      page.should have_selector('a', href: home_pricing_path)
    end
  end
  
  describe 'GET tos_path' do
    it 'gets the tos page' do

      visit home_url
      click_link 'Terms'
      
      # TODO: Add more checks when content is finished.
      page.should have_selector('ul.nav')
    end
  end
  
  describe 'GET privacy_path' do
    it 'gets the pricing page' do

      visit home_url
      click_link 'Privacy'
      
      # TODO: Add more checks when content is finished.
      page.should have_selector('ul.nav')
    end
  end
end