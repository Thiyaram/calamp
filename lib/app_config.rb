# Load ftp configuration
require 'ostruct'
require 'yaml'

config = OpenStruct.new(YAML.load_file("#{Rails.root}/config/appconfig.yml"))
::AppConfig = OpenStruct.new(config.send(Rails.env))
