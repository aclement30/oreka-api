class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.datetime :deleted_at, index: true

      t.belongs_to :couple, index: true
      t.belongs_to :balance, null: false, index: true

      t.timestamps
    end

    add_index :users, [:email], unique: true
  end
end
