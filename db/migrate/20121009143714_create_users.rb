class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :name,                   :null => false, :limit => 50
      t.string   :email,                  :null => false, :limit => 150
      t.string   :password_digest,        :null => false, :limit => 255
      t.integer  :role_id,                :null => false
      t.boolean  :active,                 :null => false, :default => false
      t.string   :password_reset_token,   :null => true,   :limit => 255
      t.datetime :password_reset_sent_at
      t.timestamps
      t.datetime :deleted_at
    end
    add_index :users, :email, :unique => true
    add_index :users, :role_id
    add_index :users, :password_reset_token
  end
end
