class Message < ActiveRecord::Base
  belongs_to :room
  belongs_to :author, class_name: "User"

  scope :last_messages,  lambda { |num = nil| includes(:author).order("id DESC").limit(num).reverse }
  scope :get_more_messages,  lambda { |num, first_msg_id| where('id < ?', first_msg_id).includes(:author).last_messages(num)}

  validates_presence_of :content, :room_id, :author_id
end
