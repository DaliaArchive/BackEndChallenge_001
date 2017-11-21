class CreateGuests < ActiveRecord::Migration[5.1]
  def change
    create_table :guests do |t|
      t.string :name
      t.json :custom_attributes

      t.timestamps
    end
    add_index :guests, :name, unique: true
  end
end
