class ApplicationController < ActionController::Base
  helper_method :current_user
  before_filter :authorize
  before_filter :mini_profiler
  protect_from_forgery

  protected

  # Verify the hacker id stored in the session is an actual user in the
  # database and ensure that user account has not been disabled.
  def authorize
    @current_user = current_user

    unless @current_user
      redirect_to login_url, notice: "Please log in."
      return
    end

    unless @current_user.enabled?
      redirect_to login_url, notice: "This account has been closed."
    end
  end
  
  # Provide access to the currently logged in user. Using this method consistantly will reduce
  # the amount of database queries run just to get the logged in user. It is also available as
  # a helper method in the views.
  def current_user
    @current_user ||= Hacker.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

  # Enable rack-mini-profiler when requested.
  def mini_profiler
    if current_user != nil
      Rack::MiniProfiler.authorize_request if current_user.admin?
    end
  end
end
