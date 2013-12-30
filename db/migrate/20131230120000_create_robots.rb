class CreateRobots < ActiveRecord::Migration
  def up    
    create_table :robots do |t|      
      t.json   :attrs
      t.json   :history

      t.timestamps
    end

  end

end