class Api::V1::MessagesController < Api::V1::BaseController

	before_action :set_room, only: [:create, :destroy]
	before_action :set_message, only: [:destroy]
	
	def create
		@message = @room.messages.build(message_params)
		if @message.save!
			render @message, status: :created
		else
			json_errors @message, :unprocessable_entity
		end
	end

	def destroy
		if @message.delete_for(current_user)
			json_message "Destroyed", :ok
		else
			json_message "Not destroyed", :ok :unprocessable_entity
		end
	end

	private

		def set_message
			@message = @room.messages.find(params[:id])
		end

		def set_room
			@room = Room.find(params[:room_id])
		end

		def message_params
			params.require(:message).permit(:content).merge(author: current_user)
		end

end