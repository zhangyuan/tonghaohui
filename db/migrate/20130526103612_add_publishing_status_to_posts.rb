class AddPublishingStatusToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :publishing_status, :integer, null: false, default: -1, limit: 1
  end
end
