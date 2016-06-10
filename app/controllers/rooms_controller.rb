class RoomsController < ApplicationController
  
  before_action :authenticate_user!

  def index
    @rooms = Room.all.includes(:creator).page(params[:page]).per_page(10)
    @room = Room.new
  end

  def show
    @room = Room.find(params[:id])
    @new_message = @room.messages.build
    if params[:chat_msg_id]
      @messages = @room.messages.get_more_messages(10,params[:chat_msg_id])
    else
      @messages = @room.messages.last_messages(10)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
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
  end

  private

    def room_params
      params.require(:room).permit(:title, :creator)
    end
end
