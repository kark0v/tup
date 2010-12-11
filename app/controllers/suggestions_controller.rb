class SuggestionsController < ApplicationController

	before_filter :require_user

  # GET /suggestions
  # GET /suggestions.xml
  def index
    @suggestions = Suggestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @suggestions }
    end
  end

  # GET /suggestions/1
  # GET /suggestions/1.xml
  def show
    @suggestion = Suggestion.find(params[:id])
  end

  # GET /suggestions/new
  # GET /suggestions/new.xml
  def new
    @suggestion = Suggestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @suggestion }
    end
  end

  # GET /suggestions/1/edit
  def edit
    @suggestion = Suggestion.find(params[:id])
  end

  # POST /suggestions
  # POST /suggestions.xml
  def create
    @suggestion = Suggestion.new(params[:suggestion])
		@suggestion.suggester_id = params[:suggestion][:suggester_id]
		@suggestion.suggest_to_id = params[:suggestion][:suggest_to_id]

		if params[:book_id]
			@suggestion.book_id = params[:suggestion][:book_id]
		end

		if params[:job_id]
    	@suggestion.job_id = params[:suggestion][:job_id]
		end

		@suggest_to = Person.find(@suggestion.suggest_to_id)

    respond_to do |format|
      if @suggestion.save
        flash[:notice] = "Suggestion was successfully sent to #{@suggest_to.name}."
        format.html { redirect_to(@suggestion) }
        format.xml  { render :xml => @suggestion, :status => :created, :location => @suggestion }
				format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @suggestion.errors, :status => :unprocessable_entity }
				format.js
      end
    end
  end

  # PUT /suggestions/1
  # PUT /suggestions/1.xml
  def update
    @suggestion = Suggestion.find(params[:id])

    respond_to do |format|
      if @suggestion.update_attributes(params[:suggestion])
        flash[:notice] = 'Suggestion was successfully updated.'
        format.html { redirect_to(@suggestion) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @suggestion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /suggestions/1
  # DELETE /suggestions/1.xml
  def destroy
    @suggestion = Suggestion.find(params[:id])
    @suggestion.destroy

		flash[:notice] = 'Suggestion was successfully removed.'

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end
end

