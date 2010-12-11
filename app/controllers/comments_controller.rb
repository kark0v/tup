class CommentsController < ApplicationController
 
  before_filter :require_user, :except => [:index, :show]

  # GET /comments
  # GET /comments.xml
  def index
    if params[:review_id].nil?
      @comments = Comment.all
    else
      @review = Review.find(params[:review_id])
      @comments = @review.comments
    end

    respond_to do |format|
      format.html
      format.xml { render :xml => @comments }
    end
  end
 
  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])
    @report = Report.new
		
    respond_to do |format|
      if(!@comment.hidden)
        format.html { render :action => "show" }
        format.xml  { render :xml => @book }
			else
			  format.html { render :action => "removed" }
        format.xml  { render :xml => @book }
			end	
    end
  end
  
  # GET /comments/new
  # GET /comments/new.xml
  def new
    @review = Review.find(params[:review_id])
    @comment = @review.comments.build
  end

  def create
    @review = Review.find(params[:review_id])
    @comment = @review.comments.build(params[:comment])

    @comment.person = current_user
    @comment.review = @review
    @report = Report.new
    
    if @comment.save
      flash[:notice] = "Comment successfully created."
      respond_to do |format|
        format.html { redirect_to review_url(@comment.review_id) }
        format.xml  { head :ok }
        format.js
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Review was successfully updated.'
        format.html { redirect_to review_url(@comment.review_id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.hidden = true		
		
		@review = @comment.review
		
	  if @comment.save
			flash[:notice] = 'Comment successfully removed.'
		end

    respond_to do |format|
      format.html { redirect_to(review_path(@comment.review)) }
      format.xml { head :ok }
      format.js
    end
  end
end
