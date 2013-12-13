class CreateRobothistories < ActiveRecord::Migration
  def change
    create_table :robothistories do |t|
      t.references :robot
      t.string :status
      t.string :field
      t.string :value

      t.timestamps
    end
  end
end
