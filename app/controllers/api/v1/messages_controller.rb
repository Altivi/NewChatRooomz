class Api::V1::MessagesController < Api::V1::BaseController

	before_action :get_room, only: [:create, :destroy]
	before_action :get_message, only: [:destroy]
	
	def create
		@message = @room.messages.build(message_params)
		if @message.save
			render @message, status: :created
		else
			render_errors @message.errors.full_messages.join(', '), :unprocessable_entity
		end
	end

	def destroy
		if @message.delete_for(current_user)
			render_message "Destroyed"
		else
			render_errors "Not destroyed", :unprocessable_entity
		end
	end

	private

	def get_message
		@message = @room.messages.find(params[:id])
	end

	def get_room
		@room = Room.find(params[:room_id])
	end

	def message_params
		params.require(:message).permit(:content).merge(author: current_user)
	end

end