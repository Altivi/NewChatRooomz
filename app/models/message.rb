class Message < ActiveRecord::Base
  belongs_to :room
  belongs_to :author, class_name: "User"

  scope :last_messages,  lambda { |num = nil| includes(:author).order("id DESC").limit(num).reverse }
  scope :get_more_messages,  lambda { |num, first_msg_id| where('id < ?', first_msg_id).includes(:author).last_messages(num)}
  scope :remaining_messages, lambda { |user| where.not(id: DeletedMessage.deleted_ids(user)) }

  validates_presence_of :room_id, :author_id
  validates :content, length: { maximum: 1000 }, presence: true
  
  def delete_for(user)
  	DeletedMessage.create({ user: user, message_id: self.id })
  end

end
