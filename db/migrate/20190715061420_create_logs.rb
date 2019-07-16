class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :ident
      t.string  :url
      t.string  :title
      t.string  :type
      t.text    :summary
      t.string  :author_url
      t.string  :author_name
      t.string  :actor_url
      t.string  :actor_name
      t.timestamps null: false
    end

    add_index :logs, :created_at
  end
end
