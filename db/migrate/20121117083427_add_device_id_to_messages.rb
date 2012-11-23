class AddDeviceIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :device_id, :integer, :null => true
    add_index :messages, :device_id
  end
end
