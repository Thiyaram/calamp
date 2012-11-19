class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :received_data, :null => false
      t.text :hex_data
      t.string :client_addr
      t.timestamps
    end
    add_index :messages, :received_data
  end
end