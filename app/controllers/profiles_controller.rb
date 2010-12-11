class ProfilesController < ApplicationController
  before_filter :require_user

  def index
    redirect_to profile_path
  end

  def show
    @person = current_user

    respond_to do |format|
      format.html # index.haml
      format.xml  { render :xml => @person }
    end
  end

  def edit
    @person = Person.find(current_user.id)
    permit "owner of :person"
  end

  # GET /people/1/following
  # GET /people/1/following.xml
  def following
    @person = Person.find(current_user.id)
		@followed = @person.followed.paginate :per_page => 12, :page => params[:page]
  end

  # GET /people/1/followers
  # GET /people/1/followers.xml
  def followers
    @person = Person.find(current_user.id)
		@followers = @person.followers.paginate :per_page => 12, :page => params[:page]
  end

	# GET /people/1/blocked
  # GET /people/1/blocked.xml
  def blocked
    @person = Person.find(current_user.id)
		@blocked = @person.blocked.paginate :per_page => 12, :page => params[:page]
  end

  def points
    @person = Person.find(current_user.id)
    @points = @person.earned_points.paginate :per_page => 20, :page => params[:page]
  end

  def endorsements
    @person = Person.find(current_user.id)
  end

  def updates
  	network = Person.find(current_user.id).followed.map(&:id)
  	@notifications = Notification.paginate(
  		:conditions => ['from_id IN (?)', network],
  		:order => 'created_at DESC',
  		:per_page => 20,
  		:page => params[:page])
  end

	### WEBSITES ###
  def websites_submissions
		@person = Person.find(current_user.id)
		@websites = @person.websites.active.paginate :per_page => 9, :page => params[:page]
  end

  def websites_reviews
    @person = Person.find(current_user.id)
    @websites_reviews = @person.reviews.active.website_reviews

		@websites_reviews = @websites_reviews.paginate :per_page => 4, :page => params[:page]
  end

  def websites_favs
		@websites = current_user.favorites.collect(&:website).reject(&:nil?).reject { |website| website.hidden }
		@websites = @websites.paginate :per_page => 9, :page => params[:page]
  end

	### JOBS ###
  def jobs_submissions
		@person = Person.find(current_user.id)
    @jobs = @person.jobs.active.paginate :per_page => 10, :page => params[:page]
  end

  def jobs_favs
		@jobs = current_user.favorites.collect(&:job).reject(&:nil?).reject { |job| job.hidden }
		@jobs = @jobs.paginate :per_page => 10, :page => params[:page]
  end

	### BOOKS ###
  def books_submissions
		@person = Person.find(current_user.id)
		@books = @person.books.active.reject{ |b| b.pending == true }.paginate :per_page => 8, :page => params[:page]
  end

  def books_reviews
    @person = Person.find(current_user.id)
    @books_reviews = @person.reviews.active.book_reviews

		@books_reviews = @books_reviews.paginate :per_page => 4, :page => params[:page]
  end

  def books_favs
		@books = current_user.favorites.collect(&:book).reject(&:nil?).reject { |book| book.hidden }
		@books = @books.reject{ |b| b.pending == true }.paginate :per_page => 8, :page => params[:page]
  end

  def books_lists
		@books = current_user.listbookss

    @finished_books = Array.new
    @reading_books = Array.new
    @reference_books = Array.new
    @wanttoread_books = Array.new
    @abandoned_books = Array.new

    @books.each do |book|
      if !book.book.hidden
				case book.status
					when 1 then @finished_books << book
					when 2 then @reading_books << book
					when 3 then @reference_books << book
					when 4 then @wanttoread_books << book
					when 5 then @abandoned_books << book
				end
			end
    end
  end

	### SETTINGS ###
  def notifications
		@person = Person.find(current_user.id)
  end

  def privacy
		@person = Person.find(current_user.id)
  end

	def edit_settings
    @setting = Setting.find(
		  :first,
      :conditions => ['person_id = ?', current_user],
      :limit => 1
		)

    respond_to do |format|
      if @setting.update_attributes(params[:setting])
        flash[:notice] = 'Settings successfully updated.'
        format.js
      else
        flash[:notice] = 'Something got wrong! Settings not updated.'
        format.js
      end
    end
	end

  def remove
		@person = Person.find(current_user.id)
  end

	def remover
    if(params[:person][:hidden] == "1")
		  @person = Person.find(current_user.id)
		  @person.hidden = true

			if @person.save
				current_user_session.destroy
				flash[:notice] = 'Account successfully removed!'
    		redirect_back_or_default new_person_session_url
			else
				flash[:error] = 'Something got wrong. Please try again later'
				redirect_to(:back)
			end
		else
			flash[:error] = 'You should confirm your decision (checking in the box below) to be to remove your account.'
			redirect_to(:back)
		end
	end
end

