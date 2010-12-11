class RatingsController < ApplicationController
  before_filter :get_class_by_name
  before_filter :require_user

  def rate
#    return unless logged_in?
    
    rateable = @rateable_class.find(params[:id])
		
		# Add points for rating if first time to rate
		if !rateable.rated_by_user?(current_user)
			rateable.add_rate_points(current_user)
		end
    
		# Delete the old ratings for current user  
    Rating.delete_all(["rateable_type = ? AND rateable_id = ? AND person_id = ?", @rateable_class.base_class.to_s, params[:id], current_user.id])
    
		# Add New Rate
		rateable.add_rating Rating.new(:rating => params[:rating], :person_id => current_user.id)
		rateable = @rateable_class.find(params[:id])

    render :update do |page|
      page.replace_html "star-ratings-block-#{rateable.id}", :partial => "rating/rate", :locals => { :asset => rateable }
      page.visual_effect :highlight, "star-ratings-block-#{rateable.id}"
    end
  end

  protected
  # Gets the rateable class based on the params[:rateable_type]
    def get_class_by_name
      bad_class = false
      begin
        @rateable_class = Module.const_get(params[:rateable_type])
      rescue NameError
      # The user is messing with the content_class…
        bad_class = true
      end
      # This means the user is doing something funky…naughty naughty…
      if bad_class
        redirect_to home_url
        return false
      end
      true
    end
end
