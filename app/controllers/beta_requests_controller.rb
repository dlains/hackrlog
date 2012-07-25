class BetaRequestsController < ApplicationController
  skip_before_filter :authorize

  # GET beta_requests
  def index
    render :index, layout: false
  end
  
  # GET beta_requests/new
  def new
    render :new, layout: false
  end
  
  # POST /beta_requests
  def create
    hacker = Hacker.new(params[:beta_request])
    hacker.enable_beta_access
    if hacker.save
      hacker.create_initial_data
      logger.info "Beta Access Saved."
      flash[:notice] = "// Your hackrLog() Beta request has been\n  // recorded. You will get further instrunctions\n  // when the Beta goes live."
      redirect_to beta_requests_path
    else
      logger.info "Beta Access Not Saved."
      flash[:notice] = "// There was a problem registering that email\n  // address for beta access. Please be\n  // sure you provide a valid email address."
      render new_beta_request_path, layout: false
    end
  end
  
  # GET /beta_requests/activate
  def activate
    Hacker.find_each(conditions: { beta_access: true }) do |hacker|
      hacker.activate_beta_access
    end
    render :activate, layout: false
  end

  # GET /beta_requests/:password_reset_token/edit
  def edit
    @hacker = Hacker.find_by_password_reset_token!(params[:id])
    render :edit, layout: 'home'
  end
  
  # PUT /beta_requests/:password_reset_token
  def update
    @hacker = Hacker.find_by_password_reset_token!(params[:id])

    @hacker.update_attributes(params[:hacker])
    @hacker.password_reset_token = nil
    @hacker.save
    cookies[:auth_token] = @hacker.auth_token
      
    redirect_to entries_url
  end
end
