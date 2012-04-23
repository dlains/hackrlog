class SearchController < ApplicationController

  def search
    if params[:search].nil?
      @entries = []
    else
      words = params[:search].split(" ").map! { |word| "'%" + word + "%'" }
      words.map! { |word| "content like " + word }
      @entries = Entry.where("hacker_id = ? and #{words.join(" or ")}", session[:hacker_id])
    end
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @entries }
    end
  end

end
