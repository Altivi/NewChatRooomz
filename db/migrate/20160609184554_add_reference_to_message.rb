class AddReferenceToMessage < ActiveRecord::Migration
  def change
    add_reference :messages, :author, references: :users, index: true
    add_reference :messages, :rooms, index: true
    add_foreign_key :messages, :users, column: :author_id
    add_foreign_key :messages, :rooms
  end
end
