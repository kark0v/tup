class ReportsController < ApplicationController
	before_filter :require_user
	before_filter :require_admin, :only => [:index, :show, :destroy, :edit, :update, :set_status]
	in_place_edit_for :report, :status
	in_place_edit_for :report, :reasons
	
	# GET /reports
  # GET /reports.xml
  def index
    @reports = Report.all
		@reportsJobs = @reports.select(&:job_id)
		@reportsBooks = @reports.select(&:book_id)
		@reportsPeople = @reports.select(&:person_id)
		@reportsWebsites = @reports.select(&:website_id)
		@reportsComments = @reports.select(&:comment_id)
		@reportsReviews = @reports.select(&:review_id)
		@reportsSPAM = @reports.select(&:message_id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.xml
  def show
    @report = Report.find(params[:id])
		if(@report.job_id) : @type = 'job' end		
		if(@report.book_id) : @type = 'book' end
		if(@report.person_id) : @type = 'person' end
		if(@report.website_id) : @type = 'website' end
		if(@report.comment_id) : @type = 'comment' end
		if(@report.review_id) : @type = 'review' end
		if(@report.message_id) : @type = 'SPAM' end
			
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.xml
  def new
    @report = Report.new
		@report.status = 'New'
		
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.xml
  def create
    @report = Report.new(params[:report])
		@report.status = 'New'

    respond_to do |format|
      if @report.save
        flash[:notice] = 'Report was successfully created.'
        format.html { redirect_to(@report) }
        format.xml  { render :xml => @report, :status => :created, :location => @report }
				format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
				format.js
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.xml
  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(params[:report])
        flash[:notice] = 'Report was successfully updated.'
        format.html { redirect_to(@report) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end
	
  # DELETE /reports/1
  # DELETE /reports/1.xml
  def destroy
    @report = Report.find(params[:id])
    @report.destroy
		
		flash[:notice] = 'Report was successfully destroyed.'
		
    respond_to do |format|
			format.html { redirect_to(reports_url) }
			format.xml  { head :ok }
			format.js
    end
  end
	
  # SETSTATUS /reports/1
  # SETSTATUS /reports/1.xml
  def set_status
    @report = Report.find(params[:id])
    @report.status = params[:value]		
		
    respond_to do |format|
      if @report.save
        flash[:notice] = "Report Status was successfully set to #{@report.status}."
        format.html { redirect_to(@report) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end
end
