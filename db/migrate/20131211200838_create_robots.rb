class CreateRobots < ActiveRecord::Migration
  def change
    create_table :robots do |t|
      t.string :name
      t.string :size
      t.string :weight
      t.string :status
      t.string :color
      t.string :age
      t.string :eyes_number
      t.string :antenna_number

      t.timestamps
    end
    add_index :robots, :name, :unique => true
  end
end
