class InboxController < ApplicationController

  before_filter :require_user

  def notifications
  	@notifications = Notification.paginate(
  		:conditions => ['to_id = ? and from_id <> ?', current_user.id, current_user.id],
  		:order => 'created_at DESC',
  		:per_page => 20,
  		:page => params[:page])
  end

	def suggestions
		@suggestions = current_user.suggestions
		@suggestions = @suggestions.paginate :order => 'created_at DESC', :per_page => 10, :page => params[:page]
  end

  def mark_sugg_as_unseen
    @suggestion = Suggestion.find(params[:id])
    @suggestion.read = false
    @suggestion.save
    render :update do |page|
      page.replace_html "suggestion#{params[:id]}", :partial => 'inbox/suggestion', :locals => { :suggestion => @suggestion }
    end
  end

  def mark_sugg_as_seen
    @suggestion = Suggestion.find(params[:id])
    @suggestion.read = true
    @suggestion.save
    render :update do |page|
      page.replace_html "suggestion#{params[:id]}", :partial => 'inbox/suggestion', :locals => { :suggestion => @suggestion }
    end
  end
end

