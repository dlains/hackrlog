class EntriesTags < ActiveRecord::Migration
  def up
    create_table :entries_tags, id: false do |t|
      t.integer :entry_id, null: false
      t.integer :tag_id, null: false
    end
  end

  def down
    drop_table :entries_tags
  end
end
