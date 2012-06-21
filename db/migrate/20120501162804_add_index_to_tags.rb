class AddIndexToTags < ActiveRecord::Migration
  def change
    add_index :tags, :name
    add_index :tags, :hacker_id
  end
end
