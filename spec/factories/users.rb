# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(50)       not null
#  email                  :string(150)      not null
#  password_digest        :string(255)      not null
#  role_id                :integer          not null
#  active                 :boolean          default(FALSE), not null
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  deleted_at             :datetime
#  activation_key         :string(32)
#  invalid_attempts       :integer
#  last_login             :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl
['superadmin', 'admin', 'user'].each do |x|
  Role.find_or_create_by_name(x)
end


