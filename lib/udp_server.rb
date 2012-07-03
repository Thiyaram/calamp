require 'eventmachine'

class UDPServer < EventMachine::Connection
  def initialize *args
    super
    @@udp_logger ||= Logger.new("#{Rails.root}/log/udp_server.log")
  end

  def post_init
    self.class.logger.info "#{Time.now} client: #{client_addr} connected successfully. \r\n"
  end

  def receive_data(data)
    self.class.logger.info "#{Time.now} Client #{client_addr} sent data: #{data.inspect} \r\n"
    send_data "success\n"
    close_connection if data =~ /quit/i
  end

  def unbind
    self.class.logger.info "#{Time.now} client #{client_addr} successfully disconnnected. \r\n"
  end
  
  def client_addr
    addr = get_peername[2,6].unpack "nC4"
    port = addr.shift
    ip   = addr.join(".")
    [ip, port].join(":")
  end
  
  def self.logger
    @@udp_logger  
  end
  
end

