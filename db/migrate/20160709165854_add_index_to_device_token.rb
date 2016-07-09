class AddIndexToDeviceToken < ActiveRecord::Migration
  def change
  	add_index :sessions, :device_token
  end
end
