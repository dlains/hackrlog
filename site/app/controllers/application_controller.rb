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
  
  def current_user
    begin
      @current_user ||= Hacker.find(session[:hacker_id])
    rescue
      logger.error "Attempt to find a non-existent hacker: #{session[:hacker_id]}."
      return nil
    end
  end
  
end
