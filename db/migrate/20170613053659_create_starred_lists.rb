class CreateStarredLists < ActiveRecord::Migration[5.1]
  def change
    create_table :starred_lists do |t|
      t.references :list
      t.references :user

      t.timestamps
    end
    add_foreign_key :starred_lists, :users, name: 'foreign_key_starred_lists_users'
    add_foreign_key :starred_lists, :lists, name: 'foreign_key_starred_lists_tasks'
    add_index :starred_lists, [:user_id], name: 'index_starred_lists_user_id'
    add_index :starred_lists, [:list_id], name: 'index_starred_lists_task_id'
  end
end
