class ApplicationController < ActionController::Base
  helper_method :current_user
  #include ::SslRequirement OLD VERSION CHECK ON NEW SSL STUFF TODO TODO
  before_filter :authorize
  protect_from_forgery

  # TODO OLD VERSION UPDATE AS NECESSARY
  #def ssl_required?
  #  return false if ::Rails.env == 'development' || ::Rails.env == 'test'
  #  super
  #end

  protected

  # Verify the hacker id stored in the session is an actual user in the
  # database and ensure that user account has not been disabled.
  def authorize
    @current_user = Hacker.find_by_id(session[:hacker_id])
    
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
    begin
      @current_user ||= Hacker.find(session[:hacker_id])
    rescue
      logger.error "Attempt to find a non-existent hacker: #{session[:hacker_id]}."
      return nil
    end
  end
  
end
