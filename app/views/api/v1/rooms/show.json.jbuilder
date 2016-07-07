json.messages @messsages, partial: 'api/v1/messages/message', as: :message
json.new_message(@new_message, :id, :content, :room_id, :created_at, :updated_at, :author_id, :room_id)