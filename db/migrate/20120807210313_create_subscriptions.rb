class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.boolean  :premium_account, default: false
      t.date     :premium_start_date
      t.string   :stripe_customer_token

      t.timestamps
    end
  end
end
