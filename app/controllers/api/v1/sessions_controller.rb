class Api::V1::SessionsController < Api::V1::BaseController
	
	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.valid_password?(params[:session][:password])
			sign_in user
			redirect_back_or user
		else
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end


end