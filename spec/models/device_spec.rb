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

require 'spec_helper'

describe Device do
    let(:admin) {Role.find_or_create_by_name('admin')}
    
    def create_device
       @device = Device.new(:imei => '123456789012345', :registered_date => Time.now)
       @device.status = false
       @device.save
       @device
    end

    before(:all) do
        create_device
    end

  context 'Mass Assignment' do
    it { should allow_mass_assignment_of(:imei)            }
    it { should allow_mass_assignment_of(:registered_date) }
    it { should_not allow_mass_assignment_of(:deleted_at)  }
    it { should_not allow_mass_assignment_of(:created_at)  }
    it { should_not allow_mass_assignment_of(:updated_at)  }
    it { should_not allow_mass_assignment_of(:status)      }
  end

  context 'Validations' do
    before(:all) do
      Device.destroy_all
      create_device
    end
    it { should validate_presence_of :imei                                           }
    it { should validate_format_of(:imei).with('123456789012345')                    }
    it { should_not validate_format_of(:imei).with('12356789012345')                 }
    it { should_not validate_format_of(:imei).with('1235678901234A')                 }
    it { should validate_presence_of(:registered_date)                               }

    it "should not allow duplicate value for imei with same deleted_at value" do
        device = Device.new(:imei => '123456789012345', :registered_date => '12/11/2011')
        device.save
        device = Device.new(:imei => '123456789012345', :registered_date => '12/11/2011')
        device.save
        device.errors.full_messages.should include("Imei has already been taken")
    end

    it "should allow duplicate value for imei for different deleted_at value" do
        device = Device.new(:imei => '123456789012345', :registered_date => '12/11/2011')
        device.deleted_at =  Time.now
        device.save
        device = Device.new(:imei => '123456789012345', :registered_date => '12/11/2011')
        device.save.should be_true
    end
  end

  context "Instance methods" do
    before do
        @device = Device.new(:imei => '123456789012345', :registered_date => '12/11/2011')
        @device.status = false
        @device.save
    end
 
    it "should change status of device" do
        device = @device.change_status
        device.status.should be_true
        device = device.change_status
        device.status.should be_false
    end

    describe "Auditlog messages" do
      it "entry to auditlog table when device is created" do
        expect{
          device = Device.create!({:imei => '223456789012345', :registered_date => '12-12-2012'})
          device = device.log_message
          device[:task_type].should eq('Device Creation')
        }.to change{Auditlog.all.count}.by(1)
      end

      it "should to auditlog table when device is updated" do
        expect{
          device = Device.first
          device.update_attribute('imei','121211234567890')
          device = device.log_message
          device[:task_type].should eq('Device Updation')
        }.to change{Auditlog.all.count}.by(1)
      end        

      it "should entry to auditlog table when device is activated" do
        expect{
          device = Device.create({:imei => '222221234567890', :registered_date => '12-12-2012'})
          device = device.change_status
          device = device.log_message
          device[:task_type].should eq('Device Activation')
        }.to change{Auditlog.all.count}.by(2)
      end

      it "should entry to auditlog table when device is deactivated" do
        expect{
          device = Device.create({:imei => '123456789009876', :registered_date => '12-12-2012'})
          device.status = true 
          device.save
          device.change_status
          device = device.log_message
          device[:task_type].should eq('Device Deactivation')
        }.to change{Auditlog.all.count}.by(3)
      end
    end

    describe "Device Deletion" do
      it "should made entry to auditlg table when device is deleted" do
        expect{
          device = Device.create({:imei => '223456789012345', :registered_date => '12-12-2012'})
          device.destroy
          device = device.log_message_for_remove_device
          device[:task_type].should eq('Device Deletion')
        }.to change{Auditlog.all.count}.by(2)
      end
    end

    it "should return auditlog message" do
      expect{
        device = Device.create({:imei => '223456789012345', :registered_date => '12-12-2012'})
        device.destroy
        device = device.audit_log_message
        device[:task_type].should eq('Device Deletion')
      }.to change{Auditlog.all.count}.by(2)
    end
  end
end
