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



  context 'Mass Assignment' do
    it { should allow_mass_assignment_of(:imei)            }
    it { should allow_mass_assignment_of(:registered_date) }
    it { should_not allow_mass_assignment_of(:deleted_at)  }
    it { should_not allow_mass_assignment_of(:created_at)  }
    it { should_not allow_mass_assignment_of(:updated_at)  }
  end

  context 'Validations' do
    before do
      Device.create!(:imei => '123456789012345', :registered_date => '12/12/2011')
    end
    it { should validate_presence_of :imei                                           }
    it { should validate_format_of(:imei).with('123456789012345')                    }
    it { should_not validate_format_of(:imei).with('12356789012345')                 }
    it { should_not validate_format_of(:imei).with('1235678901234A')                 }
    it { should validate_presence_of(:registered_date)                               }

    it "should not allow duplicate value for imei with same deleted_at value" do
        device = Device.new(:imei => '123456789012345', :registered_date => '12/11/2011')
        device.save
        device.errors.full_messages.should include("Imei has already been taken")
    end

    it "should allow duplicate value for imei for different deleted_at value" do
        device = Device.new(:imei => '123456789012345', :registered_date => '12/11/2011')
        device.deleted_at =  Time.now
        device.save.should be_true
    end
  end
end
