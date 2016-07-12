class Api::V1::BaseController < ApplicationController
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    #protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
    before_action :destroy_session, :authenticate_user!
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
    respond_to :json

    include Sessionable

    private

    def destroy_session
        request.session_options[:skip] = true
    end

    def authenticate_user!
        unless access_token = request.headers["HTTP_ACCESS_TOKEN"]
            render_errors "Unauthorized, no access_token", :unauthorized
        else
            find_session(access_token)
        end
    end

    def find_session(access_token)
        if session = Session.non_expired.find_by_access_token(access_token)
            current_session = session
            current_session.touch
        else
            render_errors "Unauthorized, session doesn't exists", :unauthorized
        end
    end

    def render_errors(message, status)
        render json: { errors: message }, status: status
    end

    def render_message(message)
        render json: { message: message }, status: :ok
    end

    def render_not_found(e)
        render json: { error: e.message }, status: :not_found
    end

    def render_parameter_missing(e)
    	render json: { error: e.message }, status: :unprocessable_entity
    end

end