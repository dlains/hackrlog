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
      session[:hacker_id] = hacker.id
      redirect_to entries_url
    else
      redirect_to login_url, notice: "Invalid email / password combination."
    end
  end

  def destroy
    session.delete :hacker_id
    redirect_to home_url, notice: "Logged out"
  end

  # POST /reset
  def reset_send
    if params[:email] == nil || params[:email] == ""
      redirect_to reset_url, :notice => 'Email address must be supplied.'
      return
    end
    hacker = Hacker.first(:conditions => ["email = ?", params[:email]])
    
    respond_to do |format|
      reset_hacker_password(hacker, false)
      Notifier.password_reset(hacker, password).deliver

      format.html {redirect_to login_url, :notice => "Your new password has been sent to your email account."}
    end
  end

  def reopen_send
    hacker = Hacker.first(:conditions => ["email = ?", params[:email]])
    
    respond_to do |format|
      reset_hacker_password(hacker, true)
      Notifier.account_reopened(hacker, password).deliver

      format.html {redirect_to login_url, :notice => "Your account has been reopened and a new password has been sent to your email account."}
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
