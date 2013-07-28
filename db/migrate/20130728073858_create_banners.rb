class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :title, null: false, default: '', limit: 100
      t.string :image, null: false, default: '', limit: 15
      t.text :url, default: ''
      t.integer :type_id, null: false, default: -1, limit: 1
      t.datetime :begin_time, null: false, default: Date.new(2000)
      t.datetime :end_time, null: false, default: Date.new(2000)
      t.integer :publishing_status, null: false, default: -1, limit: 1

      t.timestamps
    end
  end
end
