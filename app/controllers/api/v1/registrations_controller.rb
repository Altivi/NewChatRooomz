class Api::V1::RegistrationsController < Api::V1::BaseController

	skip_before_action :authenticate_user!, only: [:create]	

	def create
		user = User.new(user_params)
		if user.save
			render text: "Confirmation token sended!", status: :created
		else
			render json: user.errors, status: :unprocessable_entity
		end
	end

	private

		def user_params
			params.require(:user).permit(:email, :password, :avatar, :nickname).merge(signup_status: "active")
		end

end

# class Api::V1::RegistrationsController < Api::V1::BaseController

# 	skip_before_action :authenticate_user!, only: [:create]	

# 	def create

# 			params[:avatar] = parse_image_data(params[:avatar]) if params[:avatar]
# 			user = User.new(user_params)
# 			user.avatar = params[:avatar]

# 			if user.save
# 				render text: "Confirmation token sended!", status: :created
# 			else
# 				render json: user.errors, status: :unprocessable_entity
# 			end
# 		clean_tempfile
# 	end

# 	private

# 		def parse_image_data(image_data)
# 			@tempfile = Tempfile.new('item_image')
# 			@tempfile.binmode
# 			@tempfile.write Base64.decode64(image_data[:content])
# 			@tempfile.rewind

# 			uploaded_file = ActionDispatch::Http::UploadedFile.new(
# 				tempfile: @tempfile,
# 				filename: image_data[:filename]
# 			)

# 			uploaded_file.content_type = image_data[:content_type]
# 			uploaded_file
# 		end

# 		def clean_tempfile
# 			if @tempfile
# 				@tempfile.close
# 				@tempfile.unlink
# 			end
# 		end

# 		def user_params
# 			params.require(:user).permit(:email, :password, :nickname, avatar: [:file_name, :content, :content_type]).merge(signup_status: "active")
# 		end

# end