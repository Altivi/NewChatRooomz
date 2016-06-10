class UpdateForeignKeys < ActiveRecord::Migration
  def change
    remove_foreign_key :rooms, column: :creator_id
    remove_foreign_key :messages, column: :author_id
    remove_foreign_key :messages, :rooms

    add_foreign_key :rooms, :users, column: :creator_id, on_delete: :cascade
    add_foreign_key :messages, :users, column: :author_id, on_delete: :cascade
    add_foreign_key :messages, :rooms, on_delete: :cascade
  end
end
