class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false, default: '', limit: 20
      t.string :password_digest, null: false, default: '', limit: 80

      t.timestamps
    end
  end
end
