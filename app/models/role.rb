# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  name        :string(15)       not null
#  description :string(250)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Role < ActiveRecord::Base

  attr_accessible :name, :description

  has_many :users

  before_save :deny_update
  before_save :ensure_only_one_superadmin_exist

  validates :name,        :presence => true,
                          :length => {:maximum => 15, :allow_blank => true},
                          :uniqueness => {:case_sensitive => false, :allow_blank => true}

  validates :description, :length => {:maximum => 250, :allow_blank => true}


  def deny_update
    raise 'Role cannot be updated' unless new_record?
  end

  def ensure_only_one_superadmin_exist
    total = Role.where(:name => 'superadmin').count
    raise 'Only one superadmin can exist' if total > 1
    true
  end

end
