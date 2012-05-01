class AddIndexToEntries < ActiveRecord::Migration
  def change
    add_index :entries, :hacker_id
  end
end
