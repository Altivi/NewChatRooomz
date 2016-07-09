class RemoveExpirationDateFromSessions < ActiveRecord::Migration
  def change
  	remove_column :sessions, :expiration_date, :datetime
  end
end
