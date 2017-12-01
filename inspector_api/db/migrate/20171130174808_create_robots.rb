class CreateRobots < ActiveRecord::Migration[5.1]
  def change
    create_table :robots do |t|
      enable_extension 'hstore'
      t.string :name
      t.hstore :properties

      t.timestamps
    end
  end
end
