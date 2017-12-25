class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :date, null: false, index: true
      t.string :type, null: false, index: true
      t.string :description
      t.decimal :amount, null: false
      t.string :currency, null: false, default: 'CAD'
      t.decimal :payer_share
      t.string :notes
      t.integer :payer_id, null: false, index: true
      t.datetime :deleted_at, index: true

      t.belongs_to :category, index: true
      t.belongs_to :couple, null: false, index: true

      t.timestamps
    end

    add_foreign_key :transactions, :users, column: :payer_id
  end
end
