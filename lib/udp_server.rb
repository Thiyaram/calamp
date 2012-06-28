require 'eventmachine'

 module UDPServer
   def post_init
     Rails.logger.info "#{Time.now} client connected successfully. \r\n"
   end

   def receive_data(data)
      addr = get_peername[2,6].unpack "nC4"
      port = addr.shift
      ip   = addr.join(".")
      Rails.logger.info "#{Time.now} received data #{data.inspect} from #{ip}:#{port}  \r\n"
      send_data "success\n"
      close_connection if data =~ /quit/i
   end

   def unbind
     Rails.logger.info "#{Time.now} client successfully disconnnected. \r\n"
  end
end

