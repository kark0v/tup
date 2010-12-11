class TagsController < ApplicationController
  def index
    unless params[:website].blank?
      @tags = Tag.find(:all, :conditions => ['name LIKE ?', "%#{params[:website][:tag_list]}%"])
    else
      @tags = Tag.find(:all, :conditions => ['name LIKE ?', "%#{params[:book][:tag_list]}%"])
    end
    render :layout => false
  end
end