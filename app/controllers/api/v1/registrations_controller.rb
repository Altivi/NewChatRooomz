class Api::V1::RegistrationsController < Api::V1::BaseController

	skip_before_action :authenticate_user!, only: [:create]	

	def create
		user = User.new(user_params)
		if user.save
			json_message "Confirmation token sended!", :created
		else
			json_errors user, :unprocessable_entity
		end
	end

	private

		def user_params
			params.require(:user).permit(:email, :password, :avatar, :nickname).merge(signup_status: "active")
		end
end