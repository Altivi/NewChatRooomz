class Api::V1::RoomsController < Api::V1::BaseController
  
  before_action :get_room, only: [:show]
  before_action :get_search, only: [:index]

  def index
    @rooms = @q.result.includes(:creator).page(params[:page]).per_page(10)
  end

  def show
    @messages = @room.messages.remaining_messages(current_user)
  end

  def create
    @room = current_user.rooms.new(room_params)
    if @room.save
      render @room, status: :created
    else
      render_errors @room.errors.full_messages.join(', '), :unprocessable_entity
    end
  end

  def destroy
    @room = current_user.rooms.find(params[:id])
    if @room.destroy
      render_message "Destroyed"
    else
      render_errors "Not Destroyed", :unprocessable_entity
    end
  end

  private 

  def get_search
    @q = Room.search(params[:q])
  end

  def get_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:title)
  end

end