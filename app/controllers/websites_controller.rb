class WebsitesController < ApplicationController

  before_filter :require_user, :except => [:index, :show, :random]
  before_filter :require_owner, :only => [:edit, :update]

  # GET /websites
  # GET /websites.xml
  def index
    @page = 'browse'
		# If search is blank, check if is searching by tags, otherwise checks the filters!
    if params[:search].blank?      
      if params[:tag].blank?
        case params[:type]
          when "featured"
            @websites = Website.featured
          when "latest"
            @websites = Website.recently_submited(9)
          else
            @websites = Website.active.all
        end
      else
        @websites = Website.active.find_tagged_with(params[:tag])
        @page_header_line = "Your search for the tag <strong>" + h(params[:tag].to_s) + "</strong> returned the following results: "
        if @websites.empty?
          @page_header_line = "There are no websites with the tag: <strong>" + h(params[:tag].to_s) + "</strong>. Try a new search or <a href='#{websites_url}'>go browse</a>."
        end
      end
    else
			@page = 'search'		
      @websites = Website.active.find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"])
      if @websites.empty?
        @page_header_line = "Your search by <strong>#{h(params[:search])}</strong> did not return any websites. Try a different search or <a href='#{websites_url}'>go browse</a>."
      else
        @page_header_line = "Your search by <strong>#{h(params[:search])}</strong> returned the following results: "
      end
    end

    @websites = @websites.paginate :per_page => 9, :page => params[:page]

    @tags = Website.tag_counts

    respond_to do |format|
      format.html # index.haml
      format.xml  { render :xml => @websites }
    end
  end

  # GET /websites/1
  # GET /websites/1.xml
  def show
    @website = Website.find(params[:id])
		if current_user
			@report = Report.new
		else
			@person_session = PersonSession.new
		end

    @tags = Website.tag_counts

		respond_to do |format|
			if(!@website.hidden)
        format.html { render :action => "show" }
        format.xml  { render :xml => @website }
			else
			  @websites = Website.featured(3)
			  format.html { render :action => "removed" }
        format.xml  { render :xml => @website }
			end
    end
  end

  # GET /websites/new
  # GET /websites/new.xml
  def new
    @website = Website.new
    2.times { @website.screenshots.build }

		@tags = Website.tag_counts

    respond_to do |format|
      format.html # new.haml
      format.xml  { render :xml => @website }
    end
  end

  # GET /websites/1/edit
  def edit
    @website = Website.find(params[:id])
    @tags = Website.tag_counts
  end

  # POST /websites
  # POST /websites.xml
  def create
    @website = Website.new(params[:website])
    @website.person = current_user

    respond_to do |format|
      if @website.save
        flash[:notice] = 'Website was successfully created.'
        format.html { redirect_to(@website) }
        format.xml  { render :xml => @website, :status => :created, :location => @website }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @website.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /websites/1
  # PUT /websites/1.xml
  def update
    @website = Website.find(params[:id])

    respond_to do |format|
      if @website.update_attributes(params[:website])
        flash[:notice] = 'Website was successfully updated.'

        format.html { redirect_to(@website) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @website.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /websites/1
  # DELETE /websites/1.xml
  def destroy
    @website = Website.find(params[:id])
    @website.hidden = true
    @website.tag_list = ""
    @website.reviews.each do |review|
      review.hidden = true
      review.comments.each do |comment|
        comment.hidden = true
        if comment.save
          comment.remove_comment_submission_points
        end
      end
      if review.save
        review.remove_review_submission_points
      end
    end

		if @website.save
      @website.remove_website_submission_points
			flash[:notice] = 'Website successfully removed.'
		end

    respond_to do |format|
      format.html { redirect_to(websites_url) }
      format.xml  { head :ok }
    end
  end


  # PUT /websites/1/feature
  # PUT /websites/1/feature.xml
  def feature
    @website = Website.find(params[:id])
    @website.featured = true
    @website.save

		@website.update_website_featured_points("Featured")
		flash[:notice] = 'Website successfully featured.'

    respond_to do |format|
      format.html { redirect_to(@website) }
      format.xml { head :ok }
    end
  end

  # PUT /websites/1/unfeature
  # PUT /websites/1/unfeature.xml
  def unfeature
    @website = Website.find(params[:id])
    @website.featured = false
    @website.save

		@website.update_website_featured_points("Unfeatured")
		flash[:notice] = 'Website successfully unfeatured.'

    respond_to do |format|
      format.html { redirect_to(@website) }
      format.xml { head :ok }
    end
  end

  # PUT /websites/1/fav
  # PUT /websites/1/fav.xml
  def fav
    @website = Website.find(params[:id])

		@favorite = Favorite.new
		@favorite.person = current_user
		@favorite.website = @website
		@favorite.save
		flash[:notice] = 'Website successfully marked as Favorite.'

		respond_to do |format|
			format.html { redirect_to(:back) }
			format.xml  { head :ok }
			format.js
		end
  end

  # PUT /websites/1/unfav
  # PUT /websites/1/unfav.xml
  def unfav
    @favorite = Favorite.find(
      :first,
      :conditions => ['person_id = ? AND website_id = ?', current_user, params[:id] ],
      :limit => 1
    )
		@website = @favorite.website
		@favorite.destroy
		flash[:notice] = 'Website successfully unmarked as Favorite.'

		respond_to do |format|
			format.html { redirect_to(:back) }
			format.xml  { head :ok }
			format.js
		end
  end

  # GET /websites/1
  # GET /websites/1.xml
  def random
    @website = Website.get_random

    respond_to do |format|
      format.html { redirect_to(@website) }
      format.xml  { head :ok }
    end
  end

end
