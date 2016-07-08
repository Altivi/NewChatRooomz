json.room do
	json.partial! 'api/v1/rooms/room', room: @room

	json.messages @messages, :id, :content, :room_id, :created_at, :updated_at, :author_id, :room_id
end