# Load ftp configuration
require 'ostruct'
require 'yaml'

config = OpenStruct.new(YAML.load_file("#{Rails.root}/config/udp.yml"))
::UDPConfig = OpenStruct.new(config.send(Rails.env))
