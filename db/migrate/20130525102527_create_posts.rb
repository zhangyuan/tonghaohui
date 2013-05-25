class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, null: false, default: '', limit: 100
      t.string :url
      t.text :content

      t.timestamps
    end
  end
end
