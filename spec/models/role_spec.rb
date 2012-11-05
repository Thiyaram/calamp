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

require 'spec_helper'

describe Role do
  let (:admin) { Role.find_or_create_by_name(:name => 'admin') }

  before(:all) do
    admin
  end

  context "Validations" do
    it { should validate_presence_of(:name)                    }
    it { should ensure_length_of(:name).is_at_most(15)         }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should ensure_length_of(:description).is_at_most(250) }
  end

  context "Update" do
    it "should not allow updation" do
      role = Role.first
      expect {
        role.update_attributes(:name => 'admin1')
      }.to raise_error("Role cannot be updated")
    end
  end

end
