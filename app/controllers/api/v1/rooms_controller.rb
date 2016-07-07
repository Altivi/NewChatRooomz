class Api::V1::RoomsController < Api::V1::BaseController
	
	before_action :set_room, only: [:show, :destroy]
	before_action :set_search, only: [:index]

	def index
		@rooms = @q.result.includes(:creator).page(params[:page]).per_page(10)
		@room = Room.new
	end

	def show
    	@new_message = @room.messages.build
    	@messages = @room.messages.remaining_messages(current_user)
    	if params[:chat_msg_id]
 			@messages = @messages.get_more_messages(10,params[:chat_msg_id])
		else
			@messages = @messages.last_messages(10)
		end
	end

	def create
		@room = current_user.rooms.new(room_params)
	end

	def destroy
		@room.destroy if @room.creator?(current_user)
	end

	private 

		def set_search
	      @q = Room.search(params[:q])
	    end

	   def set_room
	      @room = Room.find(params[:id])
	   end

	   def room_params
			params.require(:room).permit(:title, :creator)
		end

end