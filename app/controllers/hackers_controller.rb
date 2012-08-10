class HackersController < ApplicationController
  layout :hacker_layout
  skip_before_filter :authorize, only: [:new, :create]

  # GET /hackers
  # GET /hackers.json
  def index
    # Never show a hacker list.
    redirect_to entries_path
  end

  # GET /hackers/1
  # GET /hackers/1.json
  def show
    # Not showing hacker info right now, perhaps this will be a profile page in the future.
    redirect_to entries_path
  end

  # GET /hackers/new
  # GET /hackers/new.json
  def new
    @hacker = Hacker.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hacker }
    end
  end

  # GET /hackers/1/edit
  def edit
    return unless modifying_self?
    @hacker = current_user
  end

  # POST /hackers
  # POST /hackers.json
  def create
    @hacker = Hacker.new(params[:hacker])

    respond_to do |format|
      if @hacker.save
        cookies[:auth_token] = @hacker.auth_token
        @hacker.create_initial_data
        Notifier.account_created(@hacker).deliver
        format.html { redirect_to entries_url, notice: "Hacker #{@hacker.email} was successfully created." }
        format.json { render json: @hacker, status: :created, location: @hacker }
      else
        format.html { render action: "new" }
        format.json { render json: @hacker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hackers/1
  # PUT /hackers/1.json
  def update
    return unless modifying_self?
    @hacker = current_user

    if params[:hacker][:activating_premium]
      respond_to do |format|
        if @hacker.update_with_premium(params[:hacker])

          format.html { redirect_to edit_hacker_path(@hacker), notice: "Congratulations, your account has been upgraded to hackrLog() Premium!" }
          format.json { head :no_content }
        else
          format.html { redirect_to edit_hacker_path(@hacker), alert: "There was a problem processing your credit card." }
          format.json { render json: @hacker.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        if @hacker.update_attributes(params[:hacker])
        
          # Check the save_tags setting. If it is false make sure the current_tags session data is cleared.
          if @hacker.save_tags == false
            if session.has_key? :current_tags
              session.delete :current_tags
            end
          end
        
          format.html { redirect_to edit_hacker_path(@hacker), notice: "Your account was successfully updated." }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @hacker.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  # GET /hacker/1/export
  def export
    return unless modifying_self?

    file = create_export_file

    send_file file, type: 'application/gz', x_sendfile: true
  end
  
  # DELETE /hackers/1
  # DELETE /hackers/1.json
  def destroy
    return unless modifying_self?
    @hacker = current_user
    
    if @hacker.authenticate(params[:cancel_password])
      @hacker.cancel_account
    
      cookies.delete :auth_token
      session.delete :filter
      session.delete :current_tags

      @hacker.destroy
      
      redirect_to home_url
    else
      redirect_to(edit_hacker_path(@hacker), alert: 'Incorrect password supplied')
    end
  end
  
  private
  
  def modifying_self?
    is_self = true
    if current_user.id != params[:id].to_i
      logger.warn "Hacker id #{current_user.id} attempted to edit Hacker with id of #{params[:id]}."
      redirect_to(entries_url, notice: 'You do not have access to that information.')
      is_self = false
    end
    is_self
  end

  def create_export_file
    exporter = Exporter.new("#{current_user.email}.#{params[:export_format]}.gz", params[:export_format])
    exporter.perform_export(current_user.entries)
    return exporter.path
  end
  
  def hacker_layout
    cookies[:auth_token] ? 'application' : 'home'
  end
  
end
