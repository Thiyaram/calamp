#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "config", "environment"))
require 'udp_server'

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
 EventMachine.run {
    EventMachine::open_datagram_socket UDPConfig.server, UDPConfig.port, UDPServer
    UDPServer.logger.info "#{Time.now} Started UDPserver at port #{UDPConfig.port}. \r\n"
  }
end
