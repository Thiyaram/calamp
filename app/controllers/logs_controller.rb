class LogsController < ApplicationController
  def index
    @logs = UDPLogViewer.limit(50) 
  end
end
