class Session < ActiveRecord::Base
	
	belongs_to :user
	before_create :set_access_token

	private

		def set_access_token
			return if access_token.present?
			self.access_token = generate_access_token
		end

		def generate_access_token
			SecureRandom.uuid.gsub(/\-/,'')
		end

end
