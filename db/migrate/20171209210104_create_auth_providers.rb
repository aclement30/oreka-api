class CreateAuthProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :auth_providers do |t|
      t.belongs_to :user, foreign_key: true, index: true, null: false
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end

    add_index :auth_providers, [:provider, :uid], unique: true
    add_index :auth_providers, [:user_id, :uid], unique: true
  end
end
