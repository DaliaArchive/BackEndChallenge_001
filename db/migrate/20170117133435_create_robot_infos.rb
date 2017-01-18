class CreateRobotInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :robot_infos do |t|
      t.integer :robot_id, index: true
      t.json :info

      t.timestamps
    end
  end
end
