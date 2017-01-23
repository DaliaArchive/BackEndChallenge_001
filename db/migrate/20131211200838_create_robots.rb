class CreateRobots < ActiveRecord::Migration
  def change
    create_table :robots do |t|
      t.string :name
      t.text :robot_datas

      t.timestamps
    end
    add_index :robots, :name, :unique => true
  end
end
