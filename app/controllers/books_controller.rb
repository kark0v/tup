class BooksController < ApplicationController
	before_filter :require_user, :except => [:index, :show, :random]

  # GET /books
  # GET /books.xml
  def index
    @page = 'browse'
		if params[:search].blank?
      if params[:tag].blank?
        case params[:type]
          when "featured"
            @books = Book.featured
          when "latest"
            @books = Book.recently_submited(9)
          else
            @books = Book.active.all
        end
      else
        @books = Book.active.find_tagged_with(params[:tag])
        @page_header_line = "Your search for the tag <strong>" + h(params[:tag].to_s) + "</strong> returned the following results: "
        if @books.empty?
          @page_header_line = "There are no books with the tag: <strong>" + h(params[:tag].to_s) + "</strong>. Try a new search or <a href='#{books_url}'>go browse</a>."
        end
      end
    else
			@page = 'search'
      @books = Book.active.find(:all, :conditions => ['title LIKE ? OR author LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%"])
      if @books.empty?
        @page_header_line = "Your search by <strong>#{h(params[:search])}</strong> did not return any books. Try a different search or <a href='#{books_url}'>go browse</a>."
      else
        @page_header_line = "Your search by <strong>#{h(params[:search])}</strong> returned the following results: "
      end
    end

    @books = @books.reject{ |b| b.pending == true }.paginate :per_page => 8, :page => params[:page]

    @tags = Book.tag_counts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @books }
    end
  end

  # GET /books/1
  # GET /books/1.xml
  def show
    @book = Book.find(params[:id])

		if current_user
			@report = Report.new
			@suggestion = Suggestion.new
			if current_user.book_onlist?(@book)
				@listbooks = Listbooks.find(:first, :conditions => ['book_id = ? AND person_id = ?', @book.id, current_user.id])
				@bookbox = "Edit"
			else
			  @listbooks = Listbooks.new
				@bookbox = "Add"
			end
		else
			@person_session = PersonSession.new
		end

    @tags = Book.tag_counts

    respond_to do |format|
      if(!@book.hidden and !@book.pending)
        format.html { render :action => "show" }
        format.xml  { render :xml => @book }
			else
				@books = Book.featured(4)
			  format.html { render :action => "removed" }
        format.xml  { render :xml => @book }
			end
    end
  end

  # GET /books/new
  # GET /books/new.xml
  def new
    @book = Book.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.xml
  def create
    @book = Book.new(params[:book])
		@book.person = current_user

    respond_to do |format|
      if @book.save
        flash[:notice] = 'Thank you for your request, your book will be reviewed as soon as possible.'
        format.html { redirect_to books_url }
        format.xml  { render :xml => @book, :status => :created, :location => @book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        flash[:notice] = 'Book was successfully updated.'
        format.html { redirect_to :back }
        format.xml  { head :ok }
      else
        format.html { redirect_to :back }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
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


  # DELETE /books/1
  # DELETE /books/1.xml
  def destroy
    @book = Book.find(params[:id])
    @book.hidden = true
    @book.tag_list = ""
    @book.reviews.each do |review|
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

		if @book.save
      @book.remove_book_submission_points
		  flash[:notice] = 'Book ' + @book.title + ' successfully removed.'
		end

    respond_to do |format|
      format.html { redirect_to(books_url) }
      format.xml  { head :ok }
    end
  end

  # PUT /books/1/feature
  # PUT /books/1/feature.xml
  def feature
    @book = Book.find(params[:id])
    @book.featured = true
    @book.save

		@book.update_book_featured_points("Featured")
		flash[:notice] = 'Book ' + @book.title + ' successfully featured.'

    respond_to do |format|
      format.html { redirect_to(@book) }
      format.xml { head :ok }
    end
  end

  # PUT /books/1/unfeature
  # PUT /books/1/unfeature.xml
  def unfeature
    @book = Book.find(params[:id])
    @book.featured = false
    @book.save

		@book.update_book_featured_points("Unfeatured")
		flash[:notice] = 'Book ' + @book.title + ' successfully unfeatured.'

    respond_to do |format|
      format.html { redirect_to(@book) }
      format.xml { head :ok }
    end
  end

  # PUT /books/1/fav
  # PUT /books/1/fav.xml
  def fav
    @book = Book.find(params[:id])

		@favorite = Favorite.new
		@favorite.person = current_user
		@favorite.book = @book
		@favorite.save
		flash[:notice] = 'Book ' + @book.title + ' successfully marked as Favorite.'

		respond_to do |format|
			format.html { redirect_to(:back) }
			format.xml  { head :ok }
			format.js
		end
  end

  # DELETE /books/1/unfav
  # DELETE /books/1/unfav.xml
  def unfav
    @favorite = Favorite.find(
      :first,
      :conditions => ['person_id = ? AND book_id = ?', current_user, params[:id] ],
      :limit => 1
    )
		@book = @favorite.book
		@favorite.destroy
		flash[:notice] = 'Book ' + @book.title + ' successfully unmarked as Favorite.'

		respond_to do |format|
			format.html { redirect_to(:back) }
			format.xml  { head :ok }
			format.js
		end
  end

  # PUT /books/1/add_to_list
  # PUT /books/1/add_to_list.xml
  def add_to_list
    @listbooks = Listbooks.new(params[:listbooks])
		@book = @listbooks.book
		@bookbox = "Edit"

    respond_to do |format|
      if @listbooks.save
        flash[:notice] = @book.title + ' was successfully added to your Lists.'
        format.html { redirect_to(@book) }
        format.xml  { render :xml => @book }
				format.js
      else
        flash[:notice] = 'Something wrong happend and your book wasn\'t added to your Lists. Try again later, Sorry.'
				format.js
      end
    end
  end

  # PUT /books/1/edit_list
  # PUT /books/1/edit_list.xml
  def edit_list
    @listbooks = Listbooks.find(
      :first,
      :conditions => ['person_id = ? AND book_id = ?', current_user, params[:id] ],
      :limit => 1
    )
		@book = @listbooks.book
		@bookbox = "Edit"

    respond_to do |format|
      if @listbooks.update_attributes(params[:listbooks])
			  flash[:notice] = @book.title + ' successfully update on your Lists.'
        format.js
      else
			  flash[:notice] = 'Something wrong happend and your book wasn\'t updated to your Lists. Try again later, Sorry.'
        format.js
      end
    end
  end

  # DELETE /books/1/remove_from_list
  # DELETE /books/1/remove_from_list.xml
  def remove_from_list
    @listbooks = Listbooks.find(
      :first,
      :conditions => ['person_id = ? AND book_id = ?', current_user, params[:id] ],
      :limit => 1
    )
		@book = @listbooks.book
		@listbooks.destroy
		flash[:notice] = @book.title + ' successfully removed from your Book Lists.'

		@listbooks = Listbooks.new
		@bookbox = "Add"

    respond_to do |format|
			format.js
    end
  end

  # GET /books/
  # GET /books/
  def random
    @book = Book.get_random

    respond_to do |format|
      format.html { redirect_to(@book) }
      format.xml  { head :ok }
    end
  end
end

