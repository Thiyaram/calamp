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

class Device < ActiveRecord::Base

  attr_accessible :imei, :registered_date

  validates :imei,           :presence   => true,
                             :length     => {:is => 15, :allow_blank => true},
                             :format     => {:with => /([0-9]){15}+/i, :allow_blank => true} ,
                             :uniqueness => {:case_sensitive => false, :scope => [:deleted_at],
                                               :allow_blank => true }

  validates :registered_date, :presence => true, :date => true

  scope :all, select('id, imei, registered_date, status').order('imei asc')

end
