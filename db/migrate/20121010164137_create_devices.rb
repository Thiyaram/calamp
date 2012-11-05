class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string   :imei,           :null => false, :limit => 30
      t.datetime :registered_date, :null => false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :devices, [:imei, :deleted_at], :unique => true
  end
end
