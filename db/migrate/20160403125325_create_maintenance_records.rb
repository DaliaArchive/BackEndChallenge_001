class CreateMaintenanceRecords < ActiveRecord::Migration
  def change
    create_table :maintenance_records do |t|
      t.integer :robot_id
      t.string :action, limit: 50

      t.timestamps null: false
    end
  end
end
