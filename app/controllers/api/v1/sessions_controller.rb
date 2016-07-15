class Api::V1::SessionsController < Api::V1::BaseController

  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_by(email: user_params[:email].downcase)
    if user && user.valid_password?(user_params[:password])
      create_for_confirmed_user(user)
    else
      render_message "Invalid email/password combination"
    end
  end

  def destroy
    current_session.delete
    render_message "Logged out"
  end

  private

  def session_create(user)
    new_session = user.sessions.build(session_params)
    if new_session.save
      render user, status: :created
      response.headers["access_token"] = new_session.access_token
    else
      puts new_session.errors.full_messages.join(', ')
      render_errors new_session.errors.full_messages.join(', '), :unprocessable_entity
    end
  end

  def create_for_confirmed_user(user)
    if user.confirmed?
      session_create(user)
    else
      render_message "You have to confirm your email address"
    end
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def session_params
    params.require(:session).permit(:device_token, :push_token, :device_type)
  end

end

