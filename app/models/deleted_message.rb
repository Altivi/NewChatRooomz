class DeletedMessage < ActiveRecord::Base
  belongs_to :user

  scope :deleted_ids, lambda { |user| where(user: user).map(&:message_id) }
end
