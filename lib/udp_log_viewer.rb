#require 'sheller'
class UDPLogViewer
  def self.limit(count=50)
    begin
      cmd = "tail -n #{count} #{UDPConfig.log_file}"
      content = `#{cmd}`
      #Sheller.execute('tail', "-n 50", TCPConfig.log_file).stdout
      content.present? ? content.split("\n\n").reverse! : []
    rescue => e
      Rails.logger.info "Error occured while fetching log. Details : #{e.inspect}"
      []
    end
  end
end
