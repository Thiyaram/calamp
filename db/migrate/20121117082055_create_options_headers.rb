class CreateOptionsHeaders < ActiveRecord::Migration
  def change
    create_table :options_headers do |t|
      t.integer   :device_id,               :null  => false
      t.integer   :message_id,              :null  => false
      t.string    :options_byte,            :null => false
      t.integer   :mobile_id_length,        :limit => 3
      t.string    :mobile_id
      t.integer   :mobile_id_type_length,   :limit => 3
      t.string    :mobile_id_type
      t.integer   :authentication_length,   :limit => 3
      t.string    :authentication_data
      t.integer   :routing_length,          :limit => 3
      t.string    :routing_data
      t.integer   :forwarding_length,       :limit => 3
      t.string    :forwarding_address
      t.string    :forwarding_port
      t.string    :forwarding_protocol
      t.string    :forwarding_operation
      t.integer   :resp_redirection_length, :limit => 3
      t.string    :resp_redirection_address
      t.string    :resp_redirection_port
      t.timestamps
    end
    add_index :options_headers, :device_id
    add_index :options_headers, :message_id
  end
end
