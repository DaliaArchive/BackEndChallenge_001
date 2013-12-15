class CreateRobots < ActiveRecord::Migration
  def change
    create_table :robots do |t|
      t.integer :size
      t.integer :weight
      t.string   :color
      t.string   :status
      t.integer :weight

      t.timestamps
    end
  end
end
