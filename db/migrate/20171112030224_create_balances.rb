class CreateBalances < ActiveRecord::Migration[5.1]
  def change
    create_table :balances do |t|
      t.decimal :amount, default: 0

      t.timestamps
    end
  end
end
