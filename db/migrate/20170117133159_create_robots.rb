class CreateRobots < ActiveRecord::Migration[5.0]
  def change
    create_table :robots do |t|

      t.timestamps
    end
  end
end
