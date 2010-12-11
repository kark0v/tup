class NotificationsController < ApplicationController

  # POST /notifications/1/comment
  def comment
    @notification = Notification.find(params[:id])
    conv = @notification.notificationconversations.new(params[:notificationconversation])
    conv.person_id = current_user.id
    conv.save

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

end

