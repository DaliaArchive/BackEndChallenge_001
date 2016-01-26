class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.string :type
      t.references :robot, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
