class Api::V1::BaseController < ApplicationController
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
	before_action :destroy_session, :authenticate_user!
	
	include ApiSessionsHelper

	private

		def destroy_session
			request.session_options[:skip] = true
		end

		def authenticate_user!
			unless request.headers["HTTP_ACCESS_TOKEN"]
				render text: "Unauthorized, no access_token", status: :unauthorized
			else
				if ses = Session.find_by_access_token(request.headers["HTTP_ACCESS_TOKEN"])
					current_session = ses
					if current_session.expired?
						current_session.delete
						render text: "Unauthorized, session expired", status: :unauthorized
					else
						current_session.touch
					end
				else
					render text: "Unauthorized, session doesn't exists", status: :unauthorized
				end
			end

		end

end