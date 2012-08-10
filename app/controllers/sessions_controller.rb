class SessionsController < ApplicationController
  layout "home"
  skip_before_filter :authorize

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
end
