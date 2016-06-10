class AfterSignupController < ApplicationController
	
	before_action :authenticate_user!
	before_action :set_user, only: [:show, :update]
	include Wicked::Wizard

	steps :choose_nickname, :choose_avatar

	def show
	    render_wizard
	end

	def update
		@user.signup_status = step.to_s
		@user.signup_status = 'active' if step == steps.last
		@user.update_attributes(user_params)
		render_wizard @user
	end

	private

	def set_user
		@user = current_user
	end

	def user_params
		params.fetch(:user,{}).permit(:nickname, :avatar)
	end

	def finish_wizard_path
		root_path
	end

end
