module SessionsHelper

	def signed_in?
		!current_user.nil?
	end	

	def current_user=(user)
		@current_user = user
	end

	def current_user
		#access_token  = request.headers["HTTP_ACCESS_TOKEN"]
		@current_user #||= Session.find_by(access_token: access_token).user
	end

	def current_user?(user)
		user == current_user
	end

end