class PersonSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @person_session = PersonSession.new
  end

  def create
    @person_session = PersonSession.new(params[:person_session])
    p = Person.find_by_email(params[:person_session][:email])
    #logger.debug "the email is #{params[:email]}"
    #logger.debug "the params are #{params}"
    #logger.debug "the person is #{p.hidden}"
    unless p.nil?
      if p.hidden
        flash[:notice] = "You are not allowed to login with this account."
        redirect_to login_url
      else
        if @person_session.save
          flash[:notice] = "Login successful! Welcome back to The Usability Page!"
          redirect_back_or_default updates_profile_path
        else
          flash[:notice] = "Login unsuccessful."
          render :action => :new
        end
      end
    else
      flash[:notice] = "Login unsuccessful."
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful! Have a nice day!"
    redirect_to root_url
  end

  def recover_password
  	respond_to do |format|
  		format.html
  	end
  end

end

