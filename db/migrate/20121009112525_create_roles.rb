class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name,        :null => false, :limit => 15
      t.string :description, :null => true,  :limit => 250
      t.timestamps
    end
    add_index :roles, :name, :unique => true
  end
end
