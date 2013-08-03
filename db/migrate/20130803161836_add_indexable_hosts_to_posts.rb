class AddIndexableHostsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :indexable_host, :string, null: false, default: '', limit: 30

    add_index :posts, [:publishing_status, :indexable_host]
  end
end
