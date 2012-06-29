class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.current_hacker_tags(current_user.id)

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
      @selected_tags = Tag.where('id = ?', params[:id])
      @entries = Entry.entries_for_tags(current_user.id, tag_ids)
      @tags = Tag.tags_used_by(@entries)
    rescue
      logger.error "Exception caught: #{$!}."
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
    @selected_tags = Tag.find_all_by_id(params[:tag_ids])
    @entries = Entry.entries_for_tags(current_user.id, params[:tag_ids])
    @tags = Tag.tags_used_by(@entries)
    
    respond_to do |format|
      format.js
    end
  end

  # GET /tags/new
  # GET /tags/new.json
  def new
    redirect_to entries_url
  end

  # GET /tags/1/edit
  def edit
    redirect_to entries_url
  end

  # POST /tags
  # POST /tags.json
  def create
    redirect_to entries_url
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    redirect_to entries_url
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    redirect_to entries_url
  end
  
end
