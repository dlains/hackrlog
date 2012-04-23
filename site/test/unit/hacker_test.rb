require 'test_helper'

class HackerTest < ActiveSupport::TestCase
  fixtures :hackers
  
  test "hacker attributes must not be empty" do
    hacker = Hacker.new
    assert hacker.invalid?
    assert hacker.errors[:email].any?
    assert hacker.errors[:password_digest].any?
  end
  
  test "email must be unique" do
    hacker = Hacker.new(:email => "dave@domain.com")
    assert hacker.invalid?
    assert_equal "has already been taken", hacker.errors[:email].join("; ")
  end

  test "hashed password is present" do
    hacker = Hacker.new(:email => "new@domain.com", :name => "haha", :password => "password", :password_confirmation => "password")
    assert hacker.valid?
    refute_nil(hacker.password_digest)
  end
  
  test "password confirmation must be included" do
    hacker = Hacker.new(:email => "another@domain.com", :name => "hehe", :password => "password")
    assert hacker.invalid?
    assert_equal "can't be blank", hacker.errors[:password_confirmation].join("; ")
  end
  
  test "does not accept enabled as batch assign" do
    hacker = hackers(:dave)
    refute_nil hacker
    params = { :hacker => { :enabled => false } }
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {hacker.update_attributes(params[:hacker])}
    #hacker.update_attributes(params[:hacker])
    assert hacker.enabled?
    hacker.enabled = false
    hacker.save
    refute hacker.enabled?
  end

  test "to_xml does not show sensitive data" do
    hacker = hackers(:dave)
    xml = hacker.to_xml
    refute_nil xml
    assert xml.include?("<id"), "xml should include id"
    assert xml.include?("<email"), "xml should include email"
    assert xml.include?("<name"), "xml should include name"
    assert xml.include?("<created-at"), "xml should include created-at"
    assert xml.include?("<updated-at"), "xml should include updated-at"
    refute xml.include?("<password-digest>"), "xml should not include password-digest"
    refute xml.include?("<enabled type=\"boolean\">"), "xml should not include enabled"
  end

end
