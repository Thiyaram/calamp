# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  received_data :text             not null
#  hex_data      :text
#  client_addr   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  device_id     :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    received_data "MyString"
    hex_data "MyString"
    client_addr "MyString"
  end
end
