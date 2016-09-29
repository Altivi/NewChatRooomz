class Web::RoomsController < Web::BaseController

	PATH_TO_PHANTOM_SCRIPT = Rails.root.join('app', 'assets', 'javascripts', 'rooms_snapshot.js')

	before_action :set_room, only: [:show, :destroy]
	before_action :set_search, only: [:index]
	after_action :take_snapshot, only: [:create]

	def index
		@rooms = @q.result.includes(:creator).page(params[:page]).per_page(10)
		@room = Room.new
	end

	def show
		@new_message = @room.messages.build
		@messages = @room.messages.remaining_messages(current_user)
		@first_message = @messages.first.id if @messages.present?
		if params[:chat_msg_id]
			@messages = @messages.get_more_messages(10,params[:chat_msg_id])
		else
			@messages = @messages.last_messages(10)
		end
		respond_to do |format|
			format.html
			format.js
		end
	end

	def create
		@room = current_user.rooms.new(room_params)
		respond_to do |format|
			if @room.save
				format.html { redirect_to @room }
				format.js
			else
				format.html { redirect_to root_path }
				format.js
			end
		end
	end

	def destroy
		@room.destroy if @room.creator?(current_user)
		respond_to do |format|
			format.html { 
				flash[:success] = "Room successfully deleted"
				redirect_to @room
			}
			format.js
		end
	end

	private

		def take_snapshot
			Dir.chdir(Rails.root.join('tmp', 'images', 'rooms_snapshots'))
			check_snapshots_count
			command = lambda { system "phantomjs #{PATH_TO_PHANTOM_SCRIPT} #{rooms_url} rooms-#{Time.now.to_i}.png" }
			if Rails.env.development?
				Thread.new do
					command.call
				end
			else
				command.call
			end
		end

		def check_snapshots_count
			curr_dir_files = Dir["**/*"]
			if curr_dir_files.length >= 5
				File.delete(curr_dir_files.min) if File.exist?(curr_dir_files.min)
			end
		end

		def set_room
			@room = Room.find(params[:id])
		end

		def set_search
			@q = Room.search(params[:q])
		end

		def room_params
			params.require(:room).permit(:title, :creator)
		end
end
