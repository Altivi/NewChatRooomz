class Api::V1::BaseController < ApplicationController
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
	before_action :destroy_session, :authenticate_user_from_token!
	include SessionsHelper

	private

		def destroy_session
			request.session_options[:skip] = true
		end

		def authenticate_user_from_token!
			if !request.headers["HTTP_ACCESS_TOKEN"]
				render text: "Unauthorized", status: :unauthorized
			else
				Session.find_each do |s|
					if s.access_token == request.headers["HTTP_ACCESS_TOKEN"]
						current_user = s.user
					end
				end
			end
		end

end