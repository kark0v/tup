class ReviewsController < ApplicationController

  before_filter :require_user, :except => [:index, :show]

  # GET /reviews
  # GET /reviews.xml
  def index
    if params[:website_id].present?
      @website = Website.find(params[:website_id])
      @reviews = @website.reviews
    else
      @reviews = Review.all
    end

    respond_to do |format|
      format.html
      format.xml { render :xml => @reviews }
    end
  end

  # GET /reviews/1
  # GET /reviews/1.xml
  def show
    @review = Review.find(params[:id])
		@report = Report.new
		@person_session = PersonSession.new

    respond_to do |format|
      if(!@review.hidden)
        format.html { render :action => "show" }
        format.xml  { render :xml => @book }
			else
			  format.html { render :action => "removed" }
        format.xml  { render :xml => @book }
			end
    end
  end

  # GET /reviews/new
  # GET /reviews/new.xml
  def new
		if params[:book_id]
			@book = Book.find(params[:book_id])
			@review = @book.reviews.build(params[:review])
		end

		if params[:website_id]
    	@website = Website.find(params[:website_id])
			@review = @website.reviews.build(params[:review])
		end
  end

  def create
		if params[:book_id]
			@book = Book.find(params[:book_id])
			@review = @book.reviews.build(params[:review])
		end

		if params[:website_id]
    	@website = Website.find(params[:website_id])
			@review = @website.reviews.build(params[:review])
		end

    @review.person = current_user
    @report = Report.new
    if @review.save
      flash[:notice] = "Review successfully created."
      respond_to do |format|
        format.html { redirect_to(@website||@book) }
        format.xml  { head :ok }
        format.js
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])

    respond_to do |format|
      if @review.update_attributes(params[:review])
        flash[:notice] = 'Review was successfully updated.'
        format.html { redirect_to(@review.website||@review.book) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.hidden = true
	  if @review.save
			flash[:notice] = 'Review successfully removed.'
		end

		if @review.book
			@book = @review.book
		end

		if @review.website
    	@website = @review.website
		end

    respond_to do |format|
      format.html { redirect_to(@review.website||@review.book) }
      format.xml { head :ok }
      format.js
    end
  end
end

