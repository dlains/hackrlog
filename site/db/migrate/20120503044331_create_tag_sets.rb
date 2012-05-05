class CreateTagSets < ActiveRecord::Migration
  def change
    create_table :tag_sets do |t|
      t.string :name, :null => false
      t.string :tags, :null => false
      t.integer :hacker_id, :null => false

      t.timestamps
    end
  end
end
