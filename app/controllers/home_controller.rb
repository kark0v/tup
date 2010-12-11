class HomeController < ApplicationController
  def index
  end

  def aboutus
    @tupmembers = Person.active.select { |p| p.has_role? 'tup_member' }
		@collaborators = Person.active.select { |p| p.has_role? 'collaborator' }
		team = @tupmembers.map(&:id) + @collaborators.map(&:id)
		@topmembers = Person.active.find(:all, :conditions => ['id NOT IN (?)', team], :order => 'total_points DESC', :limit => 6)

		@tup_members_favs = Book.find_by_sql("SELECT books.*
																				FROM books
																				INNER JOIN favorites ON books.id = favorites.book_id
																				INNER JOIN people ON favorites.person_id = people.id
																				INNER JOIN people_roles ON people.id = people_roles.person_id
																				INNER JOIN roles ON people_roles.role_id = roles.id
																				WHERE books.hidden <> true AND roles.name = 'tup_member'
																				ORDER BY RAND()
																				LIMIT 4").uniq

		respond_to do |format|
			 format.html { render :layout => 'application' }
		end
  end

  def contactus
    @person = current_user || Person.new

		respond_to do |format|
			 format.html { render :layout => 'application' }
		end
  end

  def sendmail
    @ok = Mailer::deliver_contact_message(params[:from], params[:subject], params[:body])

    respond_to do |format|
    	flash[:notice] = "Thank you for your message! #{@ok.to_s}"
      format.html { redirect_to contactus_url }
    end
  end

  def sendfeedback
  	Mailer::deliver_feedback_message(params[:feedback])

  	respond_to do |format|
  		flash[:notice] = "Thank you for your feedback!"
  		format.html { redirect_to :back }
  	end
  end

  def faq
		respond_to do |format|
			 format.html { render :layout => 'application' }
		end
  end

  def tou

		respond_to do |format|
			 format.html { render :layout => 'application' }
		end
  end

	def search
		if params[:search].blank? or params[:section][:id].blank?
			redirect_to(:controller => "home")
		else
		  @option = params[:section][:id]
			case @option
				when "1"
					redirect_to(:controller => "websites", :action => "index", :search => params[:search])
				when "2"
					redirect_to(:controller => "people", :action => "index", :search => params[:search])
				when "3"
					redirect_to(:controller => "jobs", :action => "index", :search => params[:search])
				when "4"
					redirect_to(:controller => "books", :action => "index", :search => params[:search])
				when "5"
					redirect_to(:controller => "conversations", :action => "index", :search => params[:search])
				default
					redirect_to(:controller => "home")
			end
		end
	end
end

