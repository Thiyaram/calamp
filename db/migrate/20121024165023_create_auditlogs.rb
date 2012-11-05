class CreateAuditlogs < ActiveRecord::Migration
  def change
    create_table :auditlogs do |t|
      t.integer :user_id, :default => 0
      t.string :task_type, :null => false
      t.string :task_description, :null => false
      t.text :task_detail, :null => false
      t.timestamps
    end
    add_index :auditlogs, :user_id
    add_index :auditlogs, :created_at
  end
end
