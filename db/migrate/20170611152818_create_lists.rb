class CreateLists < ActiveRecord::Migration[5.1]
  def change
    create_table :lists do |t|
      t.string :name, null: false, limit: 100
      t.references :user
      t.string :access_type, limit: 10, null: false

      t.timestamps
    end
    add_foreign_key :lists, :users, name: 'foreign_key_lists_users'
    add_index :lists, [:user_id], name: 'index_lists_user_id'
  end
end
