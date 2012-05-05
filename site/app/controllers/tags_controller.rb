class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index
    @tags = current_user.tags

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    tag_ids = []
    tag_ids << params[:id]
    begin
      @tags = Tag.where('id = ? and hacker_id = ?', params[:id], session[:hacker_id])
      @entries = Entry.entries_for_tags(session[:hacker_id], tag_ids)
    rescue
      logger.info "Exception caught: #{$!}."
      logger.error "Hacker id #{session[:hacker_id]} attempted to access a tag belonging to another user: #{params[:id]}."
      redirect_to(entries_url)
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @tag }
      end
    end
  end

  # GET /tags/combine
  def combine
    @tags = Tag.find_all_by_id_and_hacker_id(params[:tag_ids], session[:hacker_id])
    @entries = Entry.entries_for_tags(session[:hacker_id], params[:tag_ids])
    
    respond_to do |format|
      format.js
    end
  end

  # GET /tags/new
  # GET /tags/new.json
  def new
    @new_tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @new_tag = Tag.find(params[:id])
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(params[:tag])
    @tag.hacker_id = session[:hacker_id]

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.js
        format.json { render json: @tag, status: :created, location: @tag }
      else
        format.html { render action: "new" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    begin
      @tag = current_user.tags.find(params[:id])
    rescue
      logger.error "Hacker id #{session[:hacker_id]} attempted to update a tag belonging to another user: #{params[:id]}."
      redirect_to(tags_url)
    else
      respond_to do |format|
        if @tag.update_attributes(params[:tag])
          format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @tag.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    begin
      @tag = current_user.tags.find(params[:id])
    rescue
      logger.error "Hacker id #{session[:hacker_id]} attempted to delete a tag belonging to another user: #{params[:id]}."
      redirect_to(tags_url)
    else
      @tag.destroy

      respond_to do |format|
        format.html { redirect_to tags_url }
        format.js
        format.json { head :no_content }
      end
    end
  end

  # In place edit for Tag Manager.
  def set_tag_name
    if request.method != 'POST' then
      logger.warn "Attempt to in place edit with method other than POST."
      return render(:text => 'Method not allowed', :status => 405)
    end
    @tag = Tag.find(params[:id])
    @tag.update_attribute('name', params[:value])
    render :text => CGI::escapeHTML(@tag.send('name').to_s)
  end
  
end
