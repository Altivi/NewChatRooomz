class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_many :rooms, foreign_key: :creator_id
  has_many :messages, foreign_key: :author_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_attached_file :avatar, styles: { thumb: "100x100#" }, default_url: "/images/:style/missing.png",
				    storage: :dropbox,
				    dropbox_credentials: Rails.root.join("config/dropbox.yml"),
				    dropbox_options: {  path: proc { |style| "avatars/#{id}/#{avatar.original_filename}" } }

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates_presence_of :nickname, if: :active_or_choose_nickname?

  after_save :save_slow_url

  def active?
    signup_status == 'active'
  end

  def active_or_choose_nickname?
    (signup_status == 'choose_nickname' || active?) && !sign_in_count.zero?
  end

  def save_slow_url
    update_column(:fast_avatar_url, avatar.url(:thumb)) if  (self.avatar_file_name_changed? )
  end

end
