class AddFastAvatarUrlToUser < ActiveRecord::Migration
  def change
    add_column :users, :fast_avatar_url, :string
  end
end
