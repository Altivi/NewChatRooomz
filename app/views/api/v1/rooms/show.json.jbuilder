json.room do
	json.partial! 'api/v1/rooms/room', room: @room
	json.messages do
		json.partial! 'api/v1/messages/message', collection: @messages, as: :message
	end
end