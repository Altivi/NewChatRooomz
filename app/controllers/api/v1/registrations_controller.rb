class Api::V1::RegistrationsController < Api::V1::BaseController

  skip_before_action :authenticate_user!, only: [:create] 

  def create
    user = User.new(user_params)
    if user.save
      render_message "Confirmation token sended!"
    else
      render_errors user.errors.full_messages.join(', '), :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :avatar, :nickname).merge(signup_status: "active")
  end
end