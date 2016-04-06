class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.integer :maintenance_record_id
      t.string :key, limit: 100
      t.string :value

      t.timestamps null: false
    end
  end
end
