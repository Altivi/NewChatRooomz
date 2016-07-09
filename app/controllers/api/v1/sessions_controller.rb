class Api::V1::SessionsController < Api::V1::BaseController

	skip_before_action :authenticate_user!, only: [:create]	

	def create
		user = User.find_by(email: user_session_params[:email].downcase)
		if user && user.valid_password?(user_session_params[:password])
			new_session = user.sessions.build(user_session_params[:session_attributes])
			if new_session.save
				render json: new_session.access_token, status: :created
			else
				render json: new_session.errors, status: :unprocessable_entity
			end
		else
			render text: "Invalid email/password combination", status: :unauthorized
		end
	end

	def destroy
		current_session.delete
		render text: "Logged out", status: :ok
	end

	private

		def user_session_params
			params.require(:user).permit(:email, :password, { session_attributes: [:device_token, :push_token, :device_type] } )
			# { "user" : { "email" : "metallfighters@gmail.com", "password" : "123123", "session_attributes" : { "device_token" : "df5fa54gsf22ee", "device_type" : "android", "push_token" : "8sadf23sdf4f41" } } }
		end

end

