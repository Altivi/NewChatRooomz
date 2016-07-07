class Api::V1::MessagesController < Api::V1::BaseController

	before_action :set_room
	
	def create
		@message = @room.messages.build(message_params)
		@message.save!
	end

	def destroy
		@message = @room.messages.find(params[:id])
		@message.delete_for(current_user)
	end

	private

	def set_room
		@room = Room.find(params[:room_id])
	end

	def message_params
		params.require(:message).permit(:content).merge(author: current_user)
	end

end