class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :hacker_id, null: false
      t.text :content

      t.timestamps
    end
  end
end
