module MessageParser
  OPTIONS_BYTE           = 0
  MOBILE_ID_LENGTH_BYTE  = 1
  MOBILE_ID_START_BYTE   = 2

  BINARY                 = 2
  MOBILE_ID_BIT          = -1
  MOBILE_ID_TYPE_BIT     = -2
  AUTHENTICATION_BIT     = -3
  ROUTING_BIT            = -4
  FORWARDING_BIT         = -5
  REDIRECTION_BIT        = -6


  def options_byte
    data  = data_as_bytes
    data.present? ? data[OPTIONS_BYTE].hex.to_s(BINARY) : ''
  end

  def options_header_for_message(msg)
    @msg   = convert_to_hexa(msg)
    return nil unless @msg.present?

    data   = data_as_bytes
    header = {
      :options_byte => data[OPTIONS_BYTE].hex.to_s(BINARY)
    }
    total_length = 0
    bits         =  ['mobile_id', 'mobile_id_type', 'authentication', 'routing',
                     'forwarding', 'redirection']
    bits.each do |x|
      if self.send("#{x}_bit_set?")
        total_length += 1
        header.merge!("#{x}_length".to_sym => data[total_length].to_i)

        start_index   = total_length + 1
        total_length += data[total_length].to_i
        if ['mobile_id', 'mobile_id_type'].include?(x)
          header.merge!("#{x}".to_sym => data[start_index..total_length].join(''))
        else
          header.merge!("#{x}_data".to_sym => data[start_index..total_length].join(''))
        end
      end
    end
    ['service_type', 'message_type'].each do |x|
      total_length += 1
      header.merge!(x.to_sym => data[total_length].hex)
    end
    total_length += 1
    header.merge!(:sequence_number => data[total_length..(total_length + 1)].join("").hex)
    total_length += 1
    header[:mobile_id] = header[:mobile_id].to_s.gsub("f", "")
    header
  end

  def convert_to_hexa(msg)
    msg.to_hex_string
  end

  def data_as_bytes
    @msg.split(" ")
  end

  def mobile_id_bit_set?
    options_byte[MOBILE_ID_BIT] == '1'
  end

  def mobile_id_type_bit_set?
    options_byte[MOBILE_ID_TYPE_BIT] == '1'
  end

  def authentication_bit_set?
    options_byte[AUTHENTICATION_BIT] == '1'
  end

  def routing_bit_set?
    options_byte[ROUTING_BIT] == '1'
  end

  def forwarding_bit_set?
    options_byte[FORWARDING_BIT] == '1'
  end

  def redirection_bit_set?
    options_byte[REDIRECTION_BIT] == '1'
  end

  def mobile_id_type_full_name(mobile_id_type)
    @mobile_id_types ||= ['OFF', 'ESN', 'IMEI or EID', 'IMSI', 'User Defined Mobile ID',
     'Phone Number of the mobile', 'Current IP Address of the LMU' ]
    @mobile_id_types[mobile_id_type]
  end

  def service_type_full_name(id)
    @service_types ||= ['Unacknowledged Request', 'Acknowledged Request', 'Response to an Acknowledged Request']
    @service_types[id]
  end

  def message_type_full_name(id)
    @message_types ||= ['Null message', 'ACK/NAK message', 'Event Report message',
                        'ID Report message', 'User Data message', 'Application Data message',
                        'Configuration Parameter message', 'Unit Request message',
                        'Locate Report message', 'User Data with Accumulators message',
                        'Mini Event Report message']
    @message_types[id]
  end

end