class CreateRobotAttributes < ActiveRecord::Migration[5.1]
  def change
    create_table :robot_attributes do |t|
      t.string :key
      t.string :value
      t.belongs_to :robot, foreign_key: true

      t.timestamps
    end
  end
end
