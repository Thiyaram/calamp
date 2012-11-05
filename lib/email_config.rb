# Load ftp configuration
require 'ostruct'
require 'yaml'

config = OpenStruct.new(YAML.load_file("#{Rails.root}/config/email.yml"))
::EmailConfig = OpenStruct.new(config.send(Rails.env))
