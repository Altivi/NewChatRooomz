module SessionsHelper

	def signed_in?
		!current_user.nil?
	end	

	def current_user=(user)
		@current_user = user
	end

	def current_user
		access_token  = request.headers["HTTP_ACCESS_TOKEN"]
		if session = Session.find_by(access_token: access_token)
			@current_user = session.user
		else
			@current_user = nil
		end
	end

	def current_user?(user)
		user == current_user
	end

end