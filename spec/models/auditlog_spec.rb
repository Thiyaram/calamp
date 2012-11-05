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

require 'spec_helper'

describe Auditlog do
  pending "add some examples to (or delete) #{__FILE__}"
end
