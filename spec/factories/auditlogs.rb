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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :auditlog do
    user_id 1
    task_type "MyString"
    task_description "MyString"
    task_detail "MyText"
  end
end
