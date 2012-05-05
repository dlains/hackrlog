class TagSetsController < ApplicationController
  # GET /tag_sets
  # GET /tag_sets.json
  def index
    @tag_sets = TagSet.where('hacker_id = ?', session[:hacker_id]).order('name ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tag_sets }
    end
  end

  # GET /tag_sets/1
  # GET /tag_sets/1.json
  def show
    begin
      @tag_set = current_user.tag_sets.find(params[:id])
    rescue
      logger.error "Hacker id #{session[:hacker_id]} attempted to access an tag set belonging to another user: #{params[:id]}."
      redirect_to(entries_url)
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @tag_set }
      end
    end
  end

  # GET /tag_sets/new
  # GET /tag_sets/new.json
  def new
    @tag_set = TagSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag_set }
    end
  end

  # GET /tag_sets/1/edit
  def edit
    begin
      @tag_set = current_user.tag_sets.find(params[:id])
    rescue
      logger.error "Hacker id #{session[:hacker_id]} attempted to access an tag set belonging to another user: #{params[:id]}."
      redirect_to(entries_url)
    end
  end

  # POST /tag_sets
  # POST /tag_sets.json
  def create
    @tag_set = TagSet.new(params[:tag_set])
    @tag_set.hacker_id = session[:hacker_id]

    respond_to do |format|
      if @tag_set.save
        format.html { redirect_to @tag_set, notice: 'Tag set was successfully created.' }
        format.json { render json: @tag_set, status: :created, location: @tag_set }
      else
        format.html { render action: "new" }
        format.json { render json: @tag_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tag_sets/1
  # PUT /tag_sets/1.json
  def update
    begin
      @tag_set = current_user.tag_sets.find(params[:id])
    rescue
      logger.error "Hacker id #{session[:hacker_id]} attempted to access a tag set belonging to another user: #{params[:id]}."
      redirect_to(entries_url)
    else
      respond_to do |format|
        if @tag_set.update_attributes(params[:tag_set])
          format.html { redirect_to @tag_set, notice: 'Tag set was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @tag_set.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /tag_sets/1
  # DELETE /tag_sets/1.json
  def destroy
    begin
      @tag_set = current_user.tag_sets.find(params[:id])
    rescue
      logger.error "Hacker id #{session[:hacker_id]} attempted to access a tag set belonging to another user: #{params[:id]}."
      redirect_to(entries_url)
    else
      @tag_set.destroy

      respond_to do |format|
        format.html { redirect_to tag_sets_url }
        format.json { head :no_content }
      end
    end
  end
end
