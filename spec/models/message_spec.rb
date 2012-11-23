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

require 'spec_helper'

describe Message do
  pending "add some examples to (or delete) #{__FILE__}"
end
