class CreateDeletedMessages < ActiveRecord::Migration
  def change
    create_table :deleted_messages do |t|
      t.belongs_to :user, index: true, foreign_key: true, on_delete: :cascade
      t.references :message, index: true, foreign_key: true, on_delete: :cascade

      t.timestamps null: false
    end
  end
end
