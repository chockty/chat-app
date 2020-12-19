class MessagesController < ApplicationController
  def index
    @message = Message.new
    @room = Room.find(params[:room_id])
    @messages = @room.messages.includes(:user)
  end

  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)
    binding.pry
    if @message.save 
      redirect_to(room_messages_path(params[:room_id]))
    else
      @messages = @room.messages.includes(:user)
      render :index
      #renderはアクションを飛ばしてビューへアクセスする。
      #つまり、@messages = @room.messages.include(:user)を定義せずにindex.html.erbを表示しようとするのでエラーとなる。
    end
  end

  private
  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end


end
