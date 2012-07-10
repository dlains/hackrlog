class CreateHackers < ActiveRecord::Migration
  def change
    create_table :hackers do |t|
      t.string :email, null: false
      t.string :name
      t.string :password_digest, null: false
      t.string :auth_token
      t.string :time_zone, default: 'Pacific Time (US & Canada)'
      t.boolean :enabled, default: true
      t.boolean :save_tags, default: true

      t.timestamps
    end
  end
end
