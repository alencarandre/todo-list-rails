class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false, limit: 100
      t.references :list
      t.string :status, null: false, limit: 10

      t.timestamps
    end
    add_foreign_key :tasks, :lists, name: 'foreign_key_tasks_lists'
    add_index :tasks, [:list_id], name: 'index_tasks_list_id'
  end
end
