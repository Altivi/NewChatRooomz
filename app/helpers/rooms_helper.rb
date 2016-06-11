module RoomsHelper
	def room_creator?(room)
		room.creator == current_user
	end
end
