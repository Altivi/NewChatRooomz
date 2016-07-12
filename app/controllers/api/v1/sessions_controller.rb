class Api::V1::SessionsController < Api::V1::BaseController

	skip_before_action :authenticate_user!, only: [:create]

	def create
		user = User.find_by(email: user_session_params[:email].downcase)
		if user && user.valid_password?(user_session_params[:password])
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
		new_session = user.sessions.build(user_session_params[:session_attributes])
		if new_session.save
			render user, status: :created
			response.headers["access_token"] = new_session.access_token
		else
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

	def user_session_params
		params.require(:user).permit(:email, :password, { session_attributes: [:device_token, :push_token, :device_type] } )
		# { "user" : { "email" : "metallfighters@gmail.com", "password" : "123123", "session_attributes" : { "device_token" : "df5fa54gsf22ee", "device_type" : "android", "push_token" : "8sadf23sdf4f41" } } }
	end

end

