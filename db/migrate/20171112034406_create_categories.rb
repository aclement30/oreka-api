class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false, index: true
      t.belongs_to :couple, null: false, index: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_index :categories, [:couple_id, :name], unique: true
  end
end
