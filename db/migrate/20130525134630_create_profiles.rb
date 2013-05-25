class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :provider_id, null: false, default: -1, limit: 1
      t.string :uid, null: false, default: '', limit: 50

      t.timestamps
    end
  end
end
