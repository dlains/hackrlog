class SessionsController < ApplicationController
  layout "home"
  skip_before_filter :authorize

  # TODO OLD VERSION Look into how to do SSL now.
  #ssl_required :new, :create, :reset_send

  def new
  end

  def create
    hacker = Hacker.find_by_email(params[:email])
    if hacker and hacker.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = hacker.auth_token
      else
        cookies[:auth_token] = hacker.auth_token
      end
      redirect_to entries_url
    else
      redirect_to login_url, alert: "Invalid email or password combination."
    end
  end

  def destroy
    cookies.delete :auth_token
    session.delete :filter
    session.delete :current_tags
    redirect_to home_url, notice: "Logged out."
  end

  def reopen_send
    hacker = Hacker.find_by_email(params[:email])

    respond_to do |format|
      reset_hacker_password(hacker, true)
      Notifier.account_reopened(hacker, password).deliver

      format.html {redirect_to login_url, notice: "Your account has been reopened and a new password has been sent to your email account."}
    end
  end
  
  private

  def reset_hacker_password(hacker, reopen)
    password = generate_password
    hacker.password = password
    hacker.password_confirmation = password
    hacker.enabled = true if reopen
    hacker.save!
  end
  
  def generate_password
    (0...10).map{65.+(rand(25)).chr}.join
  end
end
