# == Schema Information
#
# Table name: devices
#
#  id              :integer          not null, primary key
#  imei            :string(30)       not null
#  registered_date :date             not null
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  active          :boolean          default(TRUE)
#  status          :boolean          default(FALSE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do
    imei 					"123456789012345"
    registered_date "2012-10-10"
  end
end
