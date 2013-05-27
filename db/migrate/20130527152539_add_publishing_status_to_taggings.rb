class AddPublishingStatusToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :publishing_status, :integer, null: false, default: -1
  end
end
