class AddUserIdToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :user_id, :integer, null: false, default: -1
  end
end
