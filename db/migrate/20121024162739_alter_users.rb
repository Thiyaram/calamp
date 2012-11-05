class AlterUsers < ActiveRecord::Migration
  def up
	add_column :users, :activation_key, :string, :limit => 255
	add_column :users, :invalid_attempts, :integer, :limit => 2
	add_column :users, :last_login, :datetime
	remove_index :users, :email
	add_index :users, [:email, :deleted_at], :unique => true
  end

  def down
  	remove_column :users, :activation_key
	remove_column :users, :invalid_attempts
	remove_column :users, :last_login
	remove_index :users, [:email, :deleted_at]
	add_index :users, :email, :unique => true
  end
end
