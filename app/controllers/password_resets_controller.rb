class PasswordResetsController < ApplicationController
  layout "home"
  skip_before_filter :authorize

  def new
  end

  def create
    hacker = Hacker.find_by_email(params[:reset_email])
    if hacker
      hacker.send_password_reset
      redirect_to login_url, notice: 'Email sent with password reset instructions.'
    else
      redirect_to new_password_reset_path, notice: 'Invalid Email provided for password reset.'
    end
  end
  
  def edit
    @hacker = Hacker.find_by_password_reset_token!(params[:id])
  end
  
  def update
    @hacker = Hacker.find_by_password_reset_token!(params[:id])

    if @hacker.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, alert: 'Password reset has expired.'
    elsif @hacker.update_attributes(params[:hacker])
      # TODO: Should the token and reset time be removed now?
      redirect_to login_url, notice: 'Password has been reset.'
    else
      render :edit
    end
  end
  
end
