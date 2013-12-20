class InspectorsAndRobots < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :role, :limit => 16, :null => false, :default => 'Inspector'
      t.string :username, :limit => 32, :null => false
      t.string :password, :limit => 32, :null => false
      t.string :token, :limit => 32, :null => false

      t.timestamps
    end

    create_table :robots do |t|
      t.string :name, :limit => 32, :null => false

      t.timestamps
    end

    create_table :attributes do |t|
      t.references :robot, :null => false
      t.string :key, :limit => 32, :null => false
      t.text :value, :null => true
    end
  end

  def down
    drop_table :attributes
    drop_table :robots
    drop_table :users
  end
end
