class Notifier < ActionMailer::Base
  default from: "noreply@hackrlog.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.password_reset.subject
  #
  def password_reset(hacker, password)
    @hacker = hacker
    @password = password

    mail to: @hacker.email, subject: 'hackrLog account access.'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.account_created.subject
  #
  def account_created(hacker)
    @hacker = hacker

    mail to: @hacker.email, subject: 'Welcome to hackrLog!'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.account_reopened.subject
  #
  def account_reopened(hacker, password)
    @hacker = hacker
    @password = password

    mail to: @hacker.email, subject 'hackrLog account reopened.'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.account_closed.subject
  #
  def account_closed(hacker)
    @hacker = hacker

    mail to: @hacker.email, subject: 'Sorry to see you go.'
  end
end
