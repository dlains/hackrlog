class ApplicationController < ActionController::Base
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
    hacker = Hacker.find_by_id(session[:hacker_id])
    
    unless hacker
      redirect_to login_url, notice: "Please log in."
      return
    end

    unless hacker.enabled?
      redirect_to login_url, notice: "This account has been closed."
    end
  end
end
