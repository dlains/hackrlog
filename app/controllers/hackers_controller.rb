class HackersController < ApplicationController
  layout :hacker_layout
  skip_before_filter :authorize, :only => [:new, :create]

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
        session[:hacker_id] = @hacker.id
        create_initial_user_data(@hacker)
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

    respond_to do |format|
      if @hacker.update_attributes(params[:hacker])
        
        # Check the save_tags setting. If it is false make sure the current_tags session data is cleared.
        if @hacker.save_tags == false
          if session.has_key? :current_tags
            session.delete :current_tags
          end
        end
        
        format.html { redirect_to @hacker, notice: "Hacker #{@hacker.email} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hacker.errors, status: :unprocessable_entity }
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
    # Don't destroy hackers.

    respond_to do |format|
      format.html { redirect_to entries_path }
      format.json { head :no_content }
    end
  end
  
  # POST /hackers/1/cancel
  def cancel
    return unless modifying_self?
    
    @hacker = current_user
    @hacker.enabled = false
    @hacker.save!

    Notifier.account_closed(hacker).deliver

    session.delete :hacker_id
    session.delete :admin
    
    redirect_to home_url
  end
  
  private
  
  # Get the tags needed for the sidebar.
  def update_tags
    if is_filtered?
      @tags = Tag.filtered_hacker_tags(session[:filter], current_user.id)
    else
      @tags = Tag.current_hacker_tags(current_user.id)
    end
  end
  
  def modifying_self?
    is_self = true
    if session[:hacker_id] != params[:id].to_i
      logger.warn "Hacker id #{session[:hacker_id]} attempted to edit Hacker with id of #{params[:id]}."
      redirect_to(entries_url, notice: 'You do not have access to that information.')
      is_self = false
    end
    is_self
  end

  def create_export_file
    #hacker = Hacker.includes(:entries).find(params[:id])
    #exporter = Exporter.new("#{hacker.email}.#{params[:export_format]}.gz", params[:export_format])
    #exporter.perform_export(hacker.entries)
    #return exporter.path
  end
  
  def hacker_layout
    session[:hacker_id] == nil ? "home" : "application"
  end
  
  def create_initial_user_data(hacker)
    # Text for the first log entry.
    # TODO: Update this before going live.
    # TODO: Include pointers to markdown help.
    content = "## Welcome to __hackrLog__\n\nThis is your first note. You can edit it by clicking the 'Edit' link to the left, or delete it and start fresh with a new note.\n\n### Getting Started\n\nEnter new notes at the top of the page. Notes appear in this list, newest first. As more notes are added a stream of information is created that can become very long.\n\nThis is where Tags become useful. Tags can be created automatically by adding them to a note or manually in the Tag Manager on the right. Tags are case sensative and can have spaces. Separate tags in the form with commas.\n\nWhen you wish to find a particular note or set of notes click a Tag name, either in a note or in the Tag Manager on the right. You will see a list of notes which contain the selected Tag. You will also be able to add additional Tags to refine your note selection.\n"
      
    # Create the first entry now that the tags have been created.
    hacker.entries.build({
      :content => content,
      :tag_ids => [Tag.find_by_name("todo").id]
    })
    hacker.save
  end

end
