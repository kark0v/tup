class PeopleController < ApplicationController

	# prevent duplicate emails in invites
	rescue_from ActiveRecord::StatementInvalid do |e|
		flash[:notice] = "We already have a pending invite for that email. Please be patient :)"
		redirect_to signup_url
	end

  # GET /people
  # GET /people.xml
  # GET /people.js
  def index
		@page = 'browse'
    if params[:search].blank?
		  if (params[:sort].blank? || (params[:sort] == 'name'))
      	@people = Person.active.find(:all, :order => 'name ASC')
			else
				@people = Person.active.find(:all, :order => 'total_points DESC')
			end
    else
			@page = 'search'
      @people = Person.active.find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"])
			if @people.empty?
        @page_header_line = "Your search by <strong>#{h(params[:search])}</strong> did not return any profile. Try a different search or <a href='#{people_url}'>go browse</a>."
      else
        @page_header_line = "Your search by <strong>#{h(params[:search])}</strong> returned the following results: "
      end
    end

    @people = @people.paginate :per_page => 15, :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.js { render :layout => false }
      format.xml  { render :xml => @people }
    end
  end

  # GET /people/1/following
  # GET /people/1/following.xml
  def following
    @person = Person.find(params[:id])
		@followed = @person.followed.paginate :per_page => 12, :page => params[:page]

    respond_to do |format|
			if(!@person.hidden)
				if @person.is_tup?
				  format.html { redirect_to people_path }
			  end

        format.html
        format.xml  { render :xml => @person }
			else
			  format.html { render :action => "removed" }
        format.xml  { render :xml => @person }
			end
    end
  end

  # GET /people/1/followers
  # GET /people/1/followers.xml
  def followers
    @person = Person.find(params[:id])
		@followers = @person.followers.paginate :per_page => 12, :page => params[:page]

    respond_to do |format|
			if(!@person.hidden)
				if @person.is_tup?
				  format.html { redirect_to people_path }
			  end

        format.html
        format.xml  { render :xml => @person }
			else
			  format.html { render :action => "removed" }
        format.xml  { render :xml => @person }
			end
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    @person = Person.find_by_id(params[:id]) || current_user
		if current_user
			@report = Report.new
		else
			@person_session = PersonSession.new
		end

    respond_to do |format|
			if(!@person.hidden)
				if @person.is_tup?
				  format.html { redirect_to people_path }
			  end

        format.html { render :action => "show" }
        format.xml  { render :xml => @person }
			else
			  format.html { render :action => "removed" }
        format.xml  { render :xml => @person }
			end
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new
    @invite = Invite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  def get_invited
  	@invite = Invite.new(params[:invite])
  	@person = Person.new

  	respond_to do |format|
  		if @invite.save
  			#flash[:notice] = "Thank you for your interest. We will contact you shortly!"
  			flash[:persistent_message] = "Thank you for your interest. We will be contacting you shortly. Please be sure to add noreply@theusabilitypage.com to your email client whitelist to make sure your invitation doesn't end up in the spam folder."
  			format.html { redirect_to root_url }
  		else
  			flash[:notice] = "Please try again using a valid email."
  			format.html { render :action => :new }
  		end
  	end
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])

    respond_to do |format|
      if @person.save
				@setting = Setting.new
				@setting.person = @person
				@setting.save

        flash[:notice] = 'Account for ' + @person.name + ' was successfully created.'
        format.html { redirect_to profile_path }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
    permit "tup_member"
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])
    permit "tup_member or owner of :person" do

      respond_to do |format|
        if @person.update_attributes(params[:person])
          flash[:notice] = @person.name + ' profile was successfully updated.'
          format.html { redirect_to(:back) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
        end
      end

    end
  end

  # PUT /people/1/follow
  def follow
    @person = Person.find(params[:id])

    permit "not (follower of :person or owner of :person or blocked by :person)" do
      current_user.followed << @person

      # create notification, send mail
      Person.create_notifications(current_user.id, @person.id)
      Mailer.deliver_follower_notification(current_user, @person) if @person.setting.notification_followers

			@person.add_follow_points(current_user)
			flash[:notice] = 'Nice! You are now following ' + @person.name

      respond_to do |format|
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      end
    end
  end

  # PUT /people/1/follow
  def unfollow
    @person = Person.find(params[:id])

    permit "follower of :person" do
      current_user.followed.delete(@person)

      @person.remove_unfollow_points(current_user)
      flash[:notice] = 'Ok! You are not following ' + @person.name + ' anymore'

      respond_to do |format|
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    permit "owner of :person" do

    	@person.hidden = true
			@person.save
			flash[:notice] = @person.name + 'successfully removed.'

      respond_to do |format|
        format.html { redirect_to(people_url) }
        format.xml  { head :ok }
      end
    end
  end

  # PUT /people/1/feature
  # PUT /people/1/feature.xml
  def feature
    @person = Person.find(params[:id])
    @person.featured = true
    @person.save
	  flash[:notice] = @person.name + ' successfully featured.'

    respond_to do |format|
      format.html { redirect_to(@person) }
      format.xml { head :ok }
    end
  end

  # PUT /people/1/unfeature
  # PUT /people/1/unfeature.xml
  def unfeature
    @person = Person.find(params[:id])
    @person.featured = false
    @person.save
		flash[:notice] = @person.name + ' successfully unfeatured.'

    respond_to do |format|
      format.html { redirect_to(@person) }
      format.xml { head :ok }
    end
  end

  # PUT /people/1/block
  def block
    @person = Person.find(params[:id])

    permit "not blocker of :person and not owner of :person" do

      current_user.blocked << @person  
      current_user.followed.delete @person if current_user.followed.include? @person
      if current_user.followers.include? @person
        current_user.followers.delete @person
        #remove from @person followers list, and remove the points
        @person.remove_unfollow_points(current_user)
        flash[:notice] = 'Ouch! ' + @person.name + ' is blocked and is no longer following you!'
      else
        flash[:notice] = 'Ouch! ' + @person.name + ' is blocked!'
      end

      respond_to do |format|
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      end
    end
  end

  # PUT /people/1/block
  def unblock
    @person = Person.find(params[:id])

    permit "blocker of :person" do
      current_user.blocked.delete(@person)

			flash[:notice] = @person.name + ' is unblocked!'

      respond_to do |format|
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      end
    end
  end

  # GET /people/1/fav_books
  def fav_books
    @person = Person.find(params[:id])
		@books = @person.fav_books

		@books = @books.reject{ |b| b.pending == true }.paginate :per_page => 8, :page => params[:page]

    respond_to do |format|
			if(!@person.hidden)
				if @person.is_tup?
				  format.html { redirect_to people_path }
			  end

        format.html { render :action => "fav_books" }
        format.xml  { render :xml => @person }
			else
			  format.html { render :action => "removed" }
        format.xml  { render :xml => @person }
			end
    end
  end

  # PUT /people/1/recruiters
  # PUT /people/1/recruiters.xml
  def recruiters
    @people = Person.recruiters

		@people = @people.paginate :per_page => 8, :page => params[:page]

    respond_to do |format|
      format.html # recruiters.html.erb
      format.xml { head :ok }
    end
  end

  # GET /people/newbies
  # GET /people/newbies.xml
  def newbies
    @people = Person.find(:all, :limit => 10, :conditions => ['hidden <> 1 AND email <> ?', "theusabilitypage@gmail.com"], :order => "created_at DESC").group_by{ |p| p.created_at.to_date }

    respond_to do |format|
      format.html # newbies.html.erb
      format.xml { head :ok }
    end
  end

  # GET /rss/:id
  def rss

  	person = Person.find(:first, :conditions => ['rss_id = ?', params[:id]])
  	network = person.followed.map(&:id)

  	if params[:type] == "personal"
  		conds = ['to_id = ?', person.id]
  	elsif params[:type] == "network"
  		conds = ['from_id IN (?)', network]
  	else
  		conds = ['to_id = ? OR from_id IN (?)', person.id, network]
  	end

  	@notifications = Notification.find(:all,
  		:conditions => conds,
  		:order => 'created_at DESC',
  		:limit => 50)

  	respond_to do |format|
  		format.xml { render :layout => false }
  	end
  end

end

