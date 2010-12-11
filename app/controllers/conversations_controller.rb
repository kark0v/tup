class ConversationsController < ApplicationController

  before_filter :require_user

  # GET /conversations
  # GET /conversations.xml
  def index
    if params[:search].blank?
      @conversations = current_user.conversations.find(:all, :conditions => ['conversation_memberships.status = 1'], :order => "conversations.updated_at DESC")
    else
      @conversations = current_user.conversations.find(:all, :include => :people, :conditions => ['(title LIKE ? OR people.name LIKE ?) AND conversation_memberships.status = 1', "%#{params[:search]}%", "%#{params[:search]}%"], :order => "conversations.updated_at DESC")
    end
		
		@conversations = @conversations.paginate :per_page => 10, :page => params[:page]

  end

  def new
    @conversation = Conversation.new
    @conversation.messages.build
    @conversation.messages.first.person = current_user
  end

  def create
		@p1 = Person.find(params[:conversation][:person_id])
		@p2 = Person.find(params[:message][:person_id])
    
    @conversation = Conversation.new(:title => params[:conversation][:title])
    
		@conversation.people << @p1
		@conversation.people << @p2
    
    respond_to do |format|
      if @conversation.save
        
        @conversation.messages.create(params[:message])
        
        flash[:notice] = 'Message sent successfully.'
        format.html { redirect_to conversation_path(@conversation) }
      else
        format.html { render :action => :new }
        format.xml { render :xml => @conversation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @conversation = Conversation.find(params[:id])
    @conversation.messages.build
    @conversation.messages.last.person = current_user
    @conversation_membership = ConversationMembership.new

		@report = Report.new
  end

  def auto_complete_model_for_person_name
    
    p = Person.find(current_user.id)
    
    fweds = p.followed.map(&:id)
    fwers = p.followers.map(&:id)
    
    #logger.debug  ceninhas
    @people = Person.find(
      :all,
      :conditions => ['LOWER(name) LIKE ? AND hidden <> true AND id != ? AND ( id IN (?) OR id IN (?))', "%#{params[:person][:name]}%", current_user ? current_user.id : -1, fwers, fweds],
      :limit => 5
    )
    
    render :inline => '<%= model_auto_completer_result(@people, :name) %>'
  end

	# GET 1/reply_report
  # GET 1/reply_report.xml
  def reply_report
	  @report = Report.find(params[:id])

    @conversation = Conversation.new
    @conversation.messages.build
    @conversation.people << current_user
		@conversation.people << @report.reporter
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.xml
  def destroy
    @conversation = Conversation.find(params[:id])
    @conversation.destroy

		@conversation_memberships = ConversationMembership.find(:all, :conditions => ['conversation_id = ?', @conversation.id])
		@conversation_memberships.each do |conversation_membership|
			conversation_membership.destroy
		end

		flash[:notice] = 'Conversation was successfully removed.'

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end

	# PUT 1/remover
  # PUT 1/remover.xml
  def remover
	  @conversation = Conversation.find(params[:conversation_id])
		@person = Person.find(params[:person_id])

		@conversation_membership = ConversationMembership.find(:first, :conditions => ['conversation_id = ? AND person_id = ?', @conversation.id, @person.id])
		@conversation_membership.status = 2
		@conversation_membership.save

    respond_to do |format|
			if params[:source] == 'admin_remove'
				flash[:notice] = @person.name + ' successifully removed from conversation.'
				format.html { redirect_to(:back) }
				format.xml { render :xml => @conversation.errors, :status => :unprocessable_entity }
				format.js
			else
				flash[:notice] = 'Conversation successifully removed.'
				format.html { redirect_to conversations_path }
				format.xml { render :xml => @conversation.errors, :status => :unprocessable_entity }
				format.js
			end
    end
  end
end

