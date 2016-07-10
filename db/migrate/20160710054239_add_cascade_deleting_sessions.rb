class AddCascadeDeletingSessions < ActiveRecord::Migration
  def change
    remove_foreign_key :sessions, :users
    add_foreign_key :sessions, :users, on_delete: :cascade
  end
end
