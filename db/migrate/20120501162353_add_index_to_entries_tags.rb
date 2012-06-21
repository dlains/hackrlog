class AddIndexToEntriesTags < ActiveRecord::Migration
  def change
    add_index :entries_tags, [:entry_id, :tag_id], :unique => true
  end
end
