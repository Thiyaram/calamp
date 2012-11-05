class AddStatusToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :status, :boolean, :default => false
  end
end
