require 'socket'

class UDPClient
  def initialize(server, port)
    @client = UDPSocket.new
    @server = server
    @port   = port
  end
  
  def send_message(message)
    @client.send(message, 0, @server, @port)
  end
  
  def receive_response(length=100)
    @client.recvfrom(length)
  end
end
