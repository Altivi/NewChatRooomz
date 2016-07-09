class Api::V1::RegistrationsController < Api::V1::BaseController

	skip_before_action :authenticate_user!, only: [:create]	

	def create
		user = User.new(user_params)
		if user.save
			render text: "Sign up completed!", status: :created
		else
			render json: user.errors, status: :unprocessable_entity
		end
	end

	private

		def user_params
			params.require(:user).permit(:email, :password)
		end

end