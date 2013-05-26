class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.string :title, null: false, default: '', limit: 20
      t.integer :taggable_id, null: false, default: -1
      t.string :indexable, null: false, default: '', limit: 20

      t.timestamps
    end
  end
end
