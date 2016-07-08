class Api::V1::MessagesController < Api::V1::BaseController

	before_action :set_room, only: [:create, :destroy]
	before_action :set_message, only: [:destroy]
	
	def create
		@message = @room.messages.build(message_params)
		if @message.save!
			render text: "Message created", status: :created
		else
			render json: @message.errors, status: :unprocessable_entity
		end
	end

	#### AUTH
	def destroy
		if @message.delete		#@message.delete_for(current_user)
			render text: "Destroyed", status: :ok
		else
			render text: "Not Destroyed", status: :unprocessable_entity
		end
	end

	private

		def set_message
			unless @message = @room.messages.find_by_id(params[:id])
				render text: "Message not found", status: :not_found
			end
		end

		def set_room
			unless @room = Room.find_by_id(params[:room_id])
				render text: "Room not found", status: :not_found
			end
		end

		def message_params
			params.require(:message).permit(:content, :author_id, :room_id)
		end

end