class EntriesController < ApplicationController

  # GET /entries
  # GET /entries.json
  def index
    @entry = Entry.new

    # Process any filter information provided.
    filter_changed = process_filter
    
    # Was there an endless scroll event?
    if params.has_key?(:last) && params[:last] != 'complete'
      offset = params[:last].to_i
      @scroll = true
    else
      offset = 0
      @scroll = false
    end
      
    # If the filter changed reset the offset
    offset = 0 if filter_changed
    
    @count = offset + 20
    
    if is_filtered?
      @entries = Entry.entries_for_tags(current_user.id, session[:filter], 20, offset)
    else
      @entries = Entry.where('hacker_id = ?', current_user.id).order('created_at DESC').limit(20).offset(offset)
    end

    if current_user.subscription.at_limit?
      @limit = true
      flash.now[:alert] = "You have reached the entry limit for a free account. Upgrade to <a href='#{url_for(edit_hacker_url(current_user.id))}'>hackrLog() Premium</a> to remove the limit.".html_safe
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @entries }
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    begin
      @entry = current_user.entries.find(params[:id])
    rescue
      logger.error "Hacker id #{current_user.id} attempted to access an entry belonging to another user: #{params[:id]}."
      redirect_to(entries_url)
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @entry }
      end
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/1/edit
  def edit
    begin
      @entry = current_user.entries.find(params[:id])
    rescue
      logger.error "Hacker id #{current_user.id} attempted to access and entry belonging to another user: #{params[:id]}"
      redirect_to(entries_url)
    end
  end

  # POST /entries
  # POST /entries.json
  def create
    @limit = false
    set_current_tags
    params[:entry][:tag_ids] = Tag.process_tag_names(params)
    @entry = current_user.create_entry(params[:entry])
    
    if @entry == nil
      @limit = true
      flash.now[:alert] = "Unable to create any more hackrLog() entries for this account. Upgrade to <a href='#{url_for(edit_hacker_url(current_user.id))}'>hackrLog() Premium</a> to remove this limit.".html_safe
    end
    
    if current_user.subscription.at_limit?
      @limit = true
      flash.now[:alert] = "You have reached the entry limit for a free account. Upgrade to <a href='#{url_for(edit_hacker_url(current_user.id))}'>hackrLog() Premium</a> to remove the limit.".html_safe
    end
    
    respond_to do |format|
      format.html { redirect_to entries_url }
      format.js
      format.json { render json: @entry, status: :created, location: @entry }
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  def update
    set_current_tags
    params[:entry][:tag_ids] = Tag.process_tag_names(params)
    begin
      @entry = current_user.entries.find(params[:id])
    rescue
      logger.error "Hacker id #{current_user.id} attempted to update an entry belonging to another user: #{params[:id]}."
      redirect_to(entries_url)
    else
      respond_to do |format|
        if @entry.update_attributes(params[:entry])
          format.html { redirect_to entries_url, notice: 'Entry was successfully updated.' }
          format.js
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @entry.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    begin
      @entry = current_user.entries.find(params[:id])
    rescue
      logger.error "Hacker id #{current_user.id} attempted to delete an entry belonging to another user: #{params[:id]}."
      redirect_to(entries_url)
    else
      @entry.destroy

      respond_to do |format|
        format.html { redirect_to entries_url }
        format.js
        format.json { head :no_content }
      end
    end
  end
  
  private

  # Set current tags if needed.
  def set_current_tags
    if current_user.save_tags
      unless session.has_key?(:current_tags)
        session[:current_tags] = Array.new
      end
      session[:current_tags] = params[:tags]
    end
  end
  
  # Is the /entries page being filtered?
  def is_filtered?
    if session.has_key?(:filter)
      return session[:filter].length > 0
    else
      return false
    end
  end

  # Add to or remove tag values from the filter.
  def process_filter
    # Create the session variable if necessary.
    unless session.has_key?(:filter)
      session[:filter] = Array.new
    end

    start_size = session[:filter].length
    
    # Adding to the filter?
    if params.has_key?(:add_to_filter)
      session[:filter] << params[:add_to_filter]
    end

    # Removing from the filter?
    if params.has_key?(:remove_from_filter)
      session[:filter].delete_at(session[:filter].index(params[:remove_from_filter]))
    end
    
    # Clearing the filter?
    if params.has_key?(:clear_filter)
      session[:filter].clear
    end
    # If the filter was added to or removed from the size will have changed.
    return session[:filter].length != start_size
  end
  
end
