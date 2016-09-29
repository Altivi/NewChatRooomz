class AddIndexToAccesToken < ActiveRecord::Migration
  def change
    add_index :sessions, :access_token
  end
end
