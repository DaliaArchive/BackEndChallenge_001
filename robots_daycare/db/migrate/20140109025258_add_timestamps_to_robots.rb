class AddTimestampsToRobots < ActiveRecord::Migration
  def change
    change_table(:robots) { |t| t.timestamps }
  end
end
