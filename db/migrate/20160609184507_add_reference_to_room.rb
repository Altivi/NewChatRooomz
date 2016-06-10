class AddReferenceToRoom < ActiveRecord::Migration
  def change
    add_reference :rooms, :creator, references: :users, index: true
    add_foreign_key :rooms, :users, column: :creator_id
  end
end
