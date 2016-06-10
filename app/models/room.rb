class Room < ActiveRecord::Base
	has_many :messages
	belongs_to :creator, class_name: "User"
	
	default_scope { order("created_at DESC") }

	validates_presence_of :title
end
