class ConversationMembership < ActiveRecord::Base

  belongs_to :person
  belongs_to :conversation

  validates_uniqueness_of :person_id, :scope => :conversation_id

end
