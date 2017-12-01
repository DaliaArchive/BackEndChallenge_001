class RenameTypeToTypeStr < ActiveRecord::Migration[5.1]
  def change
    rename_column :robot_changelogs, :type, :type_str
  end
end
