class LogsController < ApplicationController
  skip_before_filter :check_session
  layout 'log'

  def index
    #@logs = UDPLogViewer.limit(50)
    page = params[:page] || 1
    @logs  = Message.order("created_at DESC").paginate(:page => page, :per_page => 30)
  end

  def show
    @log = Message.find(params[:id])
  end

end
