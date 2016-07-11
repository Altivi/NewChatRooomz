class User < ActiveRecord::Base

	has_many :rooms, foreign_key: :creator_id
	has_many :messages, foreign_key: :author_id
	has_many :deleted_messages
	has_many :sessions

	accepts_nested_attributes_for :sessions

	attr_accessor :delete_avatar

	devise :database_authenticatable, :registerable,
				 :recoverable, :rememberable, :trackable, :validatable , :confirmable

	has_attached_file :avatar, styles: { thumb: "100x100#" }#, default_url: "http://lunar.gsfc.nasa.gov/webdesign/nasa-logo.png"
						# storage: :dropbox,
						# dropbox_credentials: Rails.root.join("config/dropbox.yml"),
						# dropbox_options: {  path: proc { |style| "avatars/#{id}/#{avatar.original_filename}" } }

	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
	validates :nickname, uniqueness: true, presence: true, length: { in: 2..15 } , if: :active_or_choose_nickname?

	#after_save :save_slow_url
	before_validation { fast_avatar_url.clear if delete_avatar == '1' }

	def active?
		signup_status == 'active'
	end

	def active_or_choose_nickname?
		(signup_status == 'choose_nickname' || active?) && !sign_in_count.zero?
	end

	# def save_slow_url
	# 	if avatar.url(:thumb) != fast_avatar_url && delete_avatar != '1'
	# 		self.update_column(:fast_avatar_url, avatar.url(:thumb)) 
	# 	end
	# end

	def self.last_rooms_snapshot
	  UserMailer.last_rooms_snapshot.deliver_now
	end

end
