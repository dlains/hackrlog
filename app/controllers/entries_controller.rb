class EntriesController < ApplicationController
  # GET /entries
  # GET /entries.json
  def index
    @entry = Entry.new

    # Get the logged in Hacker's entries
    hacker = Hacker.find(session[:hacker_id])
    @entries = Entry.where('hacker_id = ?', session[:hacker_id]).order('created_at DESC')
    
    # TODO OLD VERSION. REPLACE paginate with infinite scroll.
    #@entries = Entry.paginate_by_sql ['select * from entries as e where e.hacker_id = ? order by created_at desc', session[:hacker_id]],
    #  :page => params[:page], :per_page => hacker.setting.entries_per_page

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entries }
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    begin
      @entry = current_user.entries.find(params[:id])
    rescue
      logger.error "Hacker id #{session[:hacker_id]} attempted to access an entry belonging to another user: #{params[:id]}."
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
      logger.error "Hacker id #{session[:hacker_id]} attempted to access and entry belonging to another user: #{params[:id]}"
      redirect_to(entries_url)
    end
  end

  # POST /entries
  # POST /entries.json
  def create
    process_tags
    @entry = Entry.new(params[:entry])
    @entry.hacker_id = session[:hacker_id]
    
    respond_to do |format|
      if @entry.save
        format.html { redirect_to entries_url }
        format.js
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  def update
    process_tags
    begin
      @entry = current_user.entries.find(params[:id])
    rescue
      logger.error "Hacker id #{session[:hacker_id]} attempted to update an entry belonging to another user: #{params[:id]}."
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
      logger.error "Hacker id #{session[:hacker_id]} attempted to delete an entry belonging to another user: #{params[:id]}."
      redirect_to(entries_url)
    else
      @entry.destroy

      respond_to do |format|
        format.html { redirect_to entries_url }
        format.json { head :no_content }
      end
    end
  end
  
  private
  
  def process_tags
    return unless params.has_key?(:tags)
    ids = []
    tag_names = params[:tags].split(" ").collect! { |name| name.strip.downcase }

    tag_names.each do |name|
      tag = Tag.find_by_name(name)
      if tag != nil
        ids << tag.id
      else
        new_tag = Tag.new
        new_tag.name = name
        new_tag.save!
        ids << new_tag.id
      end
    end
    params[:entry][:tag_ids] = ids
  end
  
end
