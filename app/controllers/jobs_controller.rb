class JobsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :rss]

  # GET /jobs
  # GET /jobs.xml
  def index
		@page = 'browse'
    if params[:search].blank?
		  case params[:type]
				when "featured"
					@jobs = Job.featured
        when "latest"
          @jobs = Job.recently_submited(9)
				when "closed"
					@jobs = Job.closed
				else
					@jobs = Job.open
      end
    else
			@page = 'search'
      @jobs = Job.active.find(:all, :conditions => ['role LIKE ? OR company LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%"])
			if @jobs.empty?
        @page_header_line = "Your search by <strong>#{h(params[:search])}</strong> did not return any job. Try a different search or <a href='#{jobs_url}'>go browse</a>."
      else
        @page_header_line = "Your search by <strong>#{h(params[:search])}</strong> returned the following results: "
      end
    end

    @jobs = @jobs.paginate :per_page => 10, :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find(params[:id])
		if current_user
			@report = Report.new
			@suggestion = Suggestion.new
		else
			@person_session = PersonSession.new
		end

    respond_to do |format|
		  if(!@job.hidden)
        format.html { render :action => "show" }
        format.xml  { render :xml => @job }
			else
				@jobs = Job.featured(4)
			  format.html { render :action => "removed" }
        format.xml  { render :xml => @job }
			end
    end
  end

  # GET /jobs/new
  # GET /jobs/new.xml
  def new
    @job = Job.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    @job = Job.new(params[:job])
		@job.person = current_user

    respond_to do |format|
      if @job.save
        flash[:notice] = 'Job Proposal successfully created.'
        format.html { redirect_to(@job) }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /jobs/1/edit
  # GET /jobs/1/edit.xml
  def edit
    @job = Job.find(params[:id])

    respond_to do |format|
		  if(!@job.hidden)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job }
			else
				@jobs = Job.featured(4)
			  format.html { render :action => "removed" }
        format.xml  { render :xml => @job }
			end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job]) and !@job.hidden
        flash[:notice] = 'Job was successfully updated.'
        format.html { redirect_to(@job) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  def auto_complete_belongs_to_for_suggestion_person_name
    
    p = Person.find(current_user.id)
    
    fweds = p.followed.map(&:id)
    fwers = p.followers.map(&:id)
  
		@people = Person.find(
      :all,
      :conditions => ['LOWER(name) LIKE ? AND hidden <> true AND id != ? AND ( id IN (?) OR id IN (?))', "%#{params[:person][:name]}%", current_user ? current_user.id : -1, fweds, fwers],
      :limit => 5
    )
    render :inline => '<%= model_auto_completer_result(@people, :name) %>'
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find(params[:id])
    @job.hidden = true
		@job.save

		if @job.save
		  flash[:notice] = 'Job successfully removed.'
		end

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end

  # PUT /jobs/1/feature
  # PUT /jobs/1/feature.xml
  def feature
    @job = Job.find(params[:id])
    @job.featured = true
    @job.save

		@job.update_job_featured_points("Featured")
		flash[:notice] = 'Job successfully featured.'

    respond_to do |format|
      format.html { redirect_to(@job) }
      format.xml { head :ok }
    end
  end

  # PUT /jobs/1/unfeature
  # PUT /jobs/1/unfeature.xml
  def unfeature
    @job = Job.find(params[:id])
    @job.featured = false
    @job.save

		@job.update_job_featured_points("Unfeatured")
		flash[:notice] = 'Job successfully unfeatured.'

    respond_to do |format|
      format.html { redirect_to(@job) }
      format.xml { head :ok }
    end
  end

  # PUT /jobs/1/open
  # PUT /jobs/1/open.xml
  def open
    @job = Job.find(params[:id])
    @job.status = "open"
    @job.save

		flash[:notice] = 'Job Proposal is now open.'

    respond_to do |format|
      format.html { redirect_to(@job) }
      format.xml { head :ok }
    end
  end

  # PUT /jobs/1/close
  # PUT /jobs/1/close.xml
  def close
    @job = Job.find(params[:id])
    @job.status = "closed"
    @job.save

		flash[:notice] = 'Job Proposal is now closed.'

    respond_to do |format|
      format.html { redirect_to(@job) }
      format.xml { head :ok }
    end
  end

  # PUT /jobs/1/fav
  # PUT /jobs/1/fav.xml
  def fav
    @job = Job.find(params[:id])

		@favorite = Favorite.new(:person_id => current_user.id, :job_id => @job.id)
		@favorite.save
		flash[:notice] = 'Job successfully marked as Favorite.'

		respond_to do |format|
			format.html { redirect_to(:back) }
			format.xml  { head :ok }
			format.js
		end
  end

  # PUT /jobs/1/unfav
  # PUT /jobs/1/unfav.xml
  def unfav
    @favorite = Favorite.find(
      :first,
      :conditions => ['person_id = ? AND job_id = ?', current_user, params[:id] ],
      :limit => 1
    )
		@favorite.destroy
		flash[:notice] = 'Job successfully unmarked as Favorite.'

		respond_to do |format|
			format.html { redirect_to(:back) }
			format.xml  { head :ok }
			format.js
		end
  end

  # GET
  def rss
  	@jobs = Job.find(:all, :order => 'created_at DESC', :limit => 20)

  	respond_to do |format|
  		format.xml { render :layout => false }
  	end
  end
end

