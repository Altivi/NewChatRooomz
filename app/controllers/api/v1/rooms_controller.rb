class Api::V1::RoomsController < Api::V1::BaseController
	
	before_action :set_room, only: [:show, :destroy]
	before_action :set_search, only: [:index]

	def index
		@rooms = @q.result.includes(:creator).page(params[:page]).per_page(10)
	end

	#### AUTH
	def show
		@messages = @room.messages.remaining_messages()
	end

	#### AUTH
	def create
		@room = Room.new(room_params)
		if @room.save
			render :show, status: :created
		else
			render json: @room.errors, status: :unprocessable_entity
		end
	end

	#### AUTH
	def destroy 
		if @room.destroy
			render text: "Destroyed", status: :ok
		else
			render text: "Not Destroyed", status: :unprocessable_entity
		end
	end

	private 

		def set_search
			@q = Room.search(params[:q])
		end

		def set_room
			unless @room = Room.find_by_id(params[:id])
				render text: "Room not found", status: :not_found
			end
		end

		def room_params
			params.require(:room).permit(:title, :creator_id)
		end

end