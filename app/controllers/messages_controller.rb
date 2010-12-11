class MessagesController < ApplicationController
  def create
    @conversation = Conversation.find(params[:conversation_id])
    message = @conversation.messages.build params[:message]

    respond_to do |format|
      if message.save
        flash[:notice] = 'Message sent successfully.'
        format.html { redirect_to conversation_path(@conversation) }
      else
        format.html { render :action => :new }
        format.xml { render :xml => @conversation.errors, :status => :unprocessable_entity }
      end
    end
  end

end
