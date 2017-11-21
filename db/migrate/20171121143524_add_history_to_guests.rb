class AddHistoryToGuests < ActiveRecord::Migration[5.1]
  def change
    add_column :guests, :history, :json, array: true, default: []
  end
end
