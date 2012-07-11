require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  
  def setup
    @hacker = hackers(:dave)
  end
  
  test "password_reset" do
    @hacker.generate_token(:password_reset_token)
    @hacker.password_reset_sent_at = Time.zone.now
    mail = Notifier.password_reset(@hacker)
    assert_equal "hackrLog password reset.", mail.subject
    assert_equal ["#{@hacker.email}"], mail.to
    assert_equal ["noreply@hackrlog.com"], mail.from
    #assert_match "Hi", mail.body.encoded
  end

  test "account_created" do
    mail = Notifier.account_created(@hacker)
    assert_equal "Welcome to hackrLog!", mail.subject
    assert_equal ["#{@hacker.email}"], mail.to
    assert_equal ["noreply@hackrlog.com"], mail.from
    #assert_match "Hi", mail.body.encoded
  end

  test "account_reopened" do
    mail = Notifier.account_reopened(@hacker, 'NewPassword')
    assert_equal "hackrLog account reopened.", mail.subject
    assert_equal ["#{@hacker.email}"], mail.to
    assert_equal ["noreply@hackrlog.com"], mail.from
    #assert_match "Hi", mail.body.encoded
  end

  test "account_closed" do
    mail = Notifier.account_closed(@hacker)
    assert_equal "Sorry to see you go.", mail.subject
    assert_equal ["#{@hacker.email}"], mail.to
    assert_equal ["noreply@hackrlog.com"], mail.from
    #assert_match "Hi", mail.body.encoded
  end

end
