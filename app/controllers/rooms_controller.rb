class RoomsController < ApplicationController
  
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
