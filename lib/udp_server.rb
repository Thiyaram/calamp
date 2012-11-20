# You might want to change this
require 'eventmachine'
require 'rubygems'
require 'active_record'
require 'pg'
require 'yaml'

#dbconfig = YAML::load(File.open(Rails.root + 'config/database.yml'))
#config   =  dbconfig[RAILS_ENV].symbolize_keys!
#ActiveRecord::Base.establish_connection(config)


class UDPServer < EventMachine::Connection
  def initialize *args
    super
    self.class.logger
  end

  def post_init
    self.class.logger.info "#{Time.now} client: #{client_addr} connected successfully. \n"
  end

  def receive_data(data)
    begin
      status = save_data_to_db(data.to_s, client_addr)
      unless status
        self.class.logger.info "#{Time.now} - Unable to save message #{data} \n"
        message = 'success'
      else
        message = Message.generate_response(data)
      end
      send_data message
      self.class.logger.info "#{Time.now} Sent response => '#{message}' to client #{client_addr} \n"
      close_connection if data =~ /quit/i
    rescue => e
      self.class.logger.info "error: #{e.inspect}"
      #Rails.logger.info "Error occured while processing TCP data. details => #{e.inspect}"
    end
  end

  def unbind
    #self.class.logger.info "#{Time.now} client #{client_addr} successfully disconnnected. \n"
  end

  def client_addr
   begin
      addr = get_peername[2,6].unpack "nC4"
      port = addr.shift
      ip   = addr.join(".")
      [ip, port].join(":")
    rescue => e
      "<unknown ip>"
    end
  end

  def self.logger
    @@udp_logger ||= Logger.new("#{Rails.root}/#{UDPConfig.log_file}")
  end

  def save_data_to_db(data, client_addr)
    msg = Message.new(:received_data => data, :client_addr => client_addr)
    msg.save(:callbacks => false)
  end
end

