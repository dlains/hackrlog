class AddIndexToHackers < ActiveRecord::Migration
  def change
    add_index :hackers, :email, unique: true
  end
end
