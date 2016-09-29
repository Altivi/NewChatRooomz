class Web::HomeController < Web::BaseController
  
	skip_before_filter :authenticate_user!

	def index
		if user_signed_in?
			redirect_to rooms_url
		else
			@user = User.new
		end
  	end
 
end
