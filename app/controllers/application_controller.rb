class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation

  rescue_from ActiveRecord::RecordNotFound do |e|
  	render 'shared/404', :status => '404'
  end

  protected
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = PersonSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_person_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end

    def require_owner
    	begin
	    	obj = controller_name.to_class.find(params[:id])
	    	unless current_user and current_user.id == obj.person_id or current_user.is_admin?
		    	flash[:notice] = "You don't have permission to access this page"
		    	redirect_to eval("#{controller_name.singularize}_path(#{params[:id]})")
	    	end
	    end rescue false
    end
    
    def require_admin
    	begin
	    	unless current_user.is_admin?
		    	flash[:notice] = "You don't have permission to access this page"
		    	redirect_to root_url
	    	end
	    end rescue false
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end

