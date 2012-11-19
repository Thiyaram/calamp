# == Schema Information
#
# Table name: options_headers
#
#  id                       :integer          not null, primary key
#  device_id                :integer          not null
#  message_id               :integer          not null
#  options_byte             :string(255)      not null
#  mobile_id_length         :integer
#  mobile_id                :string(255)
#  mobile_id_type_length    :integer
#  mobile_id_type           :string(255)
#  authentication_length    :integer
#  authentication_data      :string(255)
#  routing_length           :integer
#  routing_data             :string(255)
#  forwarding_length        :integer
#  forwarding_address       :string(255)
#  forwarding_port          :string(255)
#  forwarding_protocol      :string(255)
#  forwarding_operation     :string(255)
#  resp_redirection_length  :integer
#  resp_redirection_address :string(255)
#  resp_redirection_port    :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'spec_helper'

describe OptionsHeader do
  pending "add some examples to (or delete) #{__FILE__}"
end
