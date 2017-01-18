class AddDeletedAtToRobotInfos < ActiveRecord::Migration[5.0]
  def change
    add_column :robot_infos, :deleted_at, :datetime
    add_index :robot_infos, :deleted_at
  end
end
