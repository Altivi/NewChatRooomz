class Api::V1::RegistrationsController < Api::V1::BaseController

	def create
		user = User.new(params[:user])
		if user.save
			render :json=> {:user => [:email => user.email, :auth_token => user.authentication_token]}, :status => 201
			return
		else
			warden.custom_failure!
			render :json=> user.errors, :status=>422
		end
	end

	private

		def user_params
			params.require(:user).permit(:email, )
		end

end