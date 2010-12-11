class PasswordResetsController < ApplicationController

	before_filter :load_user_using_perishable_token, :only => [:edit, :update]
	before_filter :require_no_user
	
	rescue_from ActiveRecord::RecordNotFound do |e|
		flash[:persistent_message] = "Couldn't find that record for password reseting. Plase try copying and pasting the link you got in your mail. In case of persistent failure, please feel free to contact us."
		redirect_to root_url
	end
	
	def create
		@user = Person.find_by_email(params[:email])
		respond_to do |format|
			if @user
				#flash[:notice] = "Instructions to reset your password have been emailed to you. Please check your email."
				flash[:persistent_message] = "Intructions to reset your password have been emailed to you. Please allow for at least 30 minutes for the email to reach your inbox."
				#@user.reset_password
  			@user.reset_perishable_token!
		  	Mailer.deliver_password_reset_intructions(@user)
				format.html { redirect_to :back }
			else
				flash[:notice] = "No user was found with that email. Please try again."
				format.html { redirect_to lostpwd_path }
			end
		end
	end

  def edit
  	respond_to do |format|
  		format.html
  	end
  end

  def update
  	@user.password = params[:password]
  	@user.password_confirmation = params[:password_confirmation]
  	
  	respond_to do |format|
  		if @user.save
  			flash[:notice] = "Password updated successfully"
  			format.html { redirect_to root_url }
  		else
  			flash[:notice] = "There was a problem updating your password. Please try again."
  			format.html { render :action => :edit }
  		end
  	end
  end
  
  private
  def load_user_using_perishable_token
  	@user = Person.find_using_perishable_token(params[:id])
  	raise ActiveRecord::RecordNotFound unless @user
  end

end
