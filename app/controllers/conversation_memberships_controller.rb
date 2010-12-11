class ConversationMembershipsController < ApplicationController

  # POST /conversation_memberships
  def create
		@conversation = Conversation.find(params[:conversation_membership][:conversation_id])
	  @person = Person.find(params[:conversation_membership][:person_id])
		
    if @conversation.already_added?(@person)
			@conversation_membership = ConversationMembership.find(:first, :conditions => ['conversation_id = ? AND person_id = ?', @conversation.id, @person.id])
			if @conversation_membership.status == 1
			  flash[:error] = @person.name + ' is already a member of this conversation.'
			else
				flash[:error] = @person.name + ' successfully re-added to conversation.'
			end
			@conversation_membership.status = 1
    	@conversation_membership.save
		else
			@conversation_membership = ConversationMembership.new(params[:conversation_membership])
    	@conversation_membership.save
			flash[:notice] = @person.name + ' successfully added to conversation.'
		end

    respond_to do |format|
      format.html { redirect_to conversation_url(@conversation_membership.conversation) }
    end
  end

  def destroy
	  @conversation = Conversation.find(params[:id])
		@person = current_user
		
		@conversation_membership = ConversationMembership.find(:first, :conditions => ['conversation_id = ? AND person_id = ?', @conversation.id, @person.id])
    @conversation_membership.status = 2
		@conversation_membership.save
		
		respond_to do |format|
      format.html { redirect_to conversations_path }
    end
  end

end
