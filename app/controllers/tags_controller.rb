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
      @tags = Tag.current_hacker_tags(current_user.id)
      @entries = Entry.entries_for_tags(current_user.id, tag_ids)
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
    @tags = Tag.current_hacker_tags(current_user.id)
    @entries = Entry.entries_for_tags(current_user.id, params[:tag_ids])
    
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
    redirect_to tags_url
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    redirect_to tags_url
  end
  
end
