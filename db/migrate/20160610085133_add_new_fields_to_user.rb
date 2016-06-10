class AddNewFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :nickname, :string
    add_column :users, :signup_status, :string
  end
end
