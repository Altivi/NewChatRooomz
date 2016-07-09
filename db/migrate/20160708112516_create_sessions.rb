class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :user, index: true, foreign_key: true
      t.string :access_token
      t.string :device_token
      t.string :push_token
      t.datetime :expiration_date, null: false
      t.string :device_type

      t.timestamps null: false
    end
  end
end
