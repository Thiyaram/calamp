require 'socket'
client = UDPSocket.new
client.connect "localhost", 20500
client.send "test message", 0
