class CreateRobotChangelogs < ActiveRecord::Migration[5.1]
  def change
    create_table :robot_changelogs do |t|
      t.string :robot_id
      t.json :changeset
      t.string :type

      t.timestamps
    end
  end
end
