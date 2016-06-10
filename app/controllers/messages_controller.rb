class MessagesController < ApplicationController

  before_action :set_message_room
  
  def create
    @message = @room.messages.build(message_params)
    @message.author = current_user
    @message.save!
  end

  def destroy
    @message = @room.messages.find(params[:id])
    @message.delete_for(current_user)
    respond_to do |format|
      format.html { redirect_to room_url(@room) }
      format.js
    end
  end

  private

  def set_message_room
    @room = Room.find(params[:room_id])
  end

  def message_params
	    params.require(:message).permit(:content)
	end

end
