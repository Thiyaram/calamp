# == Schema Information
#
# Table name: auditlogs
#
#  id               :integer          not null, primary key
#  user_id          :integer          default(0)
#  task_type        :string(255)      not null
#  task_description :string(255)      not null
#  task_detail      :text             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Auditlog < ActiveRecord::Base
  attr_accessible :task_description, :task_detail, :task_type, :user_id

  def self.log_message(user_id, task, description, detail)
  	self.create({:user_id => user_id, :task_type => task, :task_description => description,
                 :task_detail => detail })
	end
end
