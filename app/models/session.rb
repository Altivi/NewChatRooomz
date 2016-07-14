class Session < ActiveRecord::Base
	
	belongs_to :user
	before_create :set_access_token
	after_create :delete_old_sessions

	scope :non_expired, lambda { where('updated_at > ?', Time.now - ENV['SES_EXP_DATE'].to_i)}

	validates :device_type, inclusion: { in: %w(ios android), 
		message: "%{value} is not valid" }, allow_blank: true
	validates_presence_of :device_type

	def expired?
		self.updated_at + ENV['SES_EXP_DATE'].to_i < Time.now 
	end

	def self.generate_token
		SecureRandom.uuid.gsub(/\-/,'')
	end

	private

	def set_access_token
		return if access_token.present?
		self.access_token = Session.generate_token
	end

	def delete_old_sessions
		Session.where(device_token: self.device_token).where.not(user: self.user).delete_all
	end

end