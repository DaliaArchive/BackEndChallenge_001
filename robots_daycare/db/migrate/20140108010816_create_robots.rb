class CreateRobots < ActiveRecord::Migration
  def change
    create_table :robots do |t|
      t.hstore :data
    end
  end
end
