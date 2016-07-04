class Room < ActiveRecord::Base
	
	has_many :messages
	belongs_to :creator, class_name: "User"
	has_attached_file :snapshot
	
	default_scope { order("created_at DESC") }

	validates_presence_of :creator_id
	validates :title, uniqueness: true, length: { maximum: 25 }, presence: true
	validates_attachment_content_type :snapshot, content_type: /\Aimage\/.*\Z/
	
	def creator?(user)
		creator == user
	end
end
