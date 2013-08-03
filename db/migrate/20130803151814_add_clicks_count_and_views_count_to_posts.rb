class AddClicksCountAndViewsCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :clicks_count, :integer, null: false, default: 0
    add_column :posts, :views_count, :integer, null: false, default: 0
  end
end
