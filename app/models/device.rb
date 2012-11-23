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
  #attr_accessor   :current_user_id, :old_value

  validates :imei,           :presence   => true,
                             :length     => {:is => 15, :allow_blank => true},
                             :format     => {:with => /([0-9]){15}+/i, :allow_blank => true} ,
                             :uniqueness => {:case_sensitive => false, :scope => [:deleted_at],
                                               :allow_blank => true }

  validates :registered_date, :presence => true, :date => true

  scope :all, select('id, imei, registered_date, status').order('status DESC,imei ASC')
  #association

  #callbacks
	before_save    :log_message
  before_destroy :log_message_for_remove_device
  
  #Instance methods
  def change_status
    if self.status == true
      self.status = false
      self.save
    else
      self.status = true
      self.save
    end
    self
  end

	def log_message
    @log_message
		if self.new_record?
	  	@log_message = {:task_type => 'Device Creation', :task_description => "New device #{self.imei} is added",
  		 :task_detail =>  ActiveSupport::JSON.encode({:imei => self.imei, :registered_date => self.registered_date,
																									:status => self.status}) }
    elsif self.changed? and self.status != self.status_was and self.status == true
      @log_message = {:task_type => "Device Activation", :task_description => "Device #{self.imei} is activated",
                  :task_detail => ActiveSupport::JSON.encode({:status_was => self.status_was, :status => self.status})}      
    elsif self.changed? and self.status != self.status_was and self.status == false
      @log_message = {:task_type => "Device Deactivation", :task_description => "Device #{self.imei} is deactivated",
                  :task_detail => ActiveSupport::JSON.encode({:status_was => self.status_was, :status => self.status})}            
		elsif self.changed?
      @log_message = {:task_type => 'Device Updation', :task_description => "Device #{self.imei} is changed",
                      :task_detail => ActiveSupport::JSON.encode({:imei => self.imei, :imei_was => self.imei_was, 
                           :registered_date => self.registered_date, :registerd_date_was => self.registered_date_was})}
    end
		@log_message
	end

  def log_message_for_remove_device
    @log_message = {:task_type => 'Device Deletion', :task_description => "Device #{self.imei} is removed", 
                    :task_detail => ActiveSupport::JSON.encode({:status_was => self.status_was, :status => self.status})}
    @log_message              
  end
	
  def audit_log_message	
		@log_message
	end
end
