class DeletedMessage < ActiveRecord::Base
  
	belongs_to :user

	scope :deleted_messages_ids, lambda { |user| where(user: user).map(&:message_id) }
	validates_presence_of :user_id, :message_id
end
