class Api::V1::BaseController < ApplicationController
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :null_session#, only: Proc.new { |c| c.request.format.json? }
	before_action :destroy_session, :authenticate_user!
	rescue_from ActiveRecord::RecordNotFound, with: :not_found
	respond_to :json

	include Sessionable

	private

		def destroy_session
			request.session_options[:skip] = true
		end

		def authenticate_user!
			unless access_token = request.headers["HTTP_ACCESS_TOKEN"]
				json_message "Unauthorized, no access_token", :unauthorized
			else
				find_session(access_token)
			end
		end

		def find_session(access_token)
			if session = Session.find_by_access_token(access_token)
				if session.expired?
					session.delete
					json_message "Unauthorized, session expired", :unauthorized
				else
					current_session = session
					current_session.touch
				end
			else
				json_message "Unauthorized, session doesn't exists", :unauthorized
			end
		end

		def json_errors(obj,status)
			render json: { errors: obj.errors.full_messages }, status: status
		end

		def json_message(msg,status)
			render json: { message: msg }, status: status
		end

		def not_found(e)
			render json: { error: e.message }, status: :not_found
		end

end