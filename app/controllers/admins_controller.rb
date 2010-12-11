class AdminsController < ApplicationController
  def index
  end
  
  def logs
    @logs = (Book.find(:all, :include => :person)+Website.find(:all, :include => :person)+Job.find(:all, :include => :person)+Review.find(:all, :include => [:person, :book, :website])).group_by{ |l| l.created_at.to_date }.sort{ |x,y| y <=> x }
  end

  def suggestions
		@suggestions = Suggestion.all
  end

  def endorsements
		@endorsements = Endorsement.all
  end

  def conversations
		@conversations = Conversation.all
  end

  def books_for_review
    @books = Book.find(:all, :conditions => ['pending = ? AND hidden = ?', true, false])
  end

  def review_book
    @book = Book.find(params[:id])
  end

	#
  def publish_book
    @book = Book.find(params[:book_id])

    respond_to do |format|
      if params[:submit].downcase.gsub(" ", "_") == "save_without_publishing"
        if @book.update_attributes(params[:book])
          flash[:notice] = "Book edited successfully"
        else
          flash[:notice] = "Error editing book"
        end
        format.html { redirect_to :controller => 'admin', :action => 'review_book', :id => @book.id }
      else
        if @book.update_attributes(params[:book].merge({ :pending => false }))
        
          Mailer.deliver_book_published(@book) if @book.person.setting.notification_books
          
          flash[:notice] = "Book published successfully, email sent to user who submited book."
          format.html { redirect_to @book }
        else
          flash[:notice] = "Error publishing book"
          format.html { redirect_to :controller => 'admin', :action => 'review_book', :id => @book.id }
        end
      end
    end
  end

	#
  def reject_book
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes({ :hidden => true, :pending => true })
        flash[:notice] = "Book is now rejected"
        format.html { redirect_to books_for_review_admin_url }
      else
        flash[:notice] = "Error rejecting book. Please try again"
        format.html { redirect_to :controller => 'admin', :action => 'review_book', :id => @book.id }
      end
    end
  end

	#
  def rejected_books
    @books = Book.find(:all, :conditions => ['hidden = ? AND pending = ?', true, true])
  end
  
  #
  def pending_invites
  	@invites = Invite.find(:all, :conditions => ['accepted = ?', false], :order => 'created_at ASC')
  end
  
  def sent_invites
    @invites = Invite.find(:all, :conditions => ['accepted = ?', true])
    @people = Person.find(:all, :conditions => ['email in (?)', @invites.map(&:email)], :order => 'last_login_at ASC')
  end
  
  #
  def give_invite
  	@invite = Invite.find(params[:id])
  	
  	# CREATE ALL LOGIC FOR USER CREATION AND EMAIL SENDING
  	passwd = Person.new_pwd
  	name = @invite.email.gsub(/@.*$/, '').gsub(/[\.\-\_]/, ' ').titleize
  	person = Person.new(:email => @invite.email, :password => passwd, :password_confirmation => passwd, :name => name)
  	
		if person.save
			@invite.accepted = true
			@invite.save
	  	Mailer::deliver_invite(person, passwd)
			flash[:notice] = "User created and invite successfully sent to #{@invite.email}."
		else
			flash[:notice] = "Error creating user. Pleasy try again and make sure that this email is not already taken."
		end
  	
  	respond_to do |format|
  		format.html { redirect_to pending_invites_admin_url }
  	end
  end
  
  def resend_invite
    person = Person.find(params[:id])
    
    passwd = Person.new_pwd
    person.password = passwd
    person.password_confirmation = passwd
    
    if person.save
	  	Mailer::deliver_invite(person, passwd)
			flash[:notice] = "Invite successfully re-sent to #{person.email}."
    else
			flash[:notice] = "Error resending invite. Pleasy try again."
    end
  	
  	respond_to do |format|
  		format.html { redirect_to sent_invites_admin_url }
  	end
  end

end

