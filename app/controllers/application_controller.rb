class ApplicationController < ActionController::Base
	include UserInfo
  #force_ssl
  protect_from_forgery

  before_filter :check_session
	helper_method :current_user

  def current_user
  	User.find(session[:user_id]) if session[:user_id].present?
  end
  
  def check_session
    request.session_options[:expire_after] = AppConfig.session_expiry_time.to_i.minutes
		UserInfo.current_user = session[:user_id]
    unless session[:user_id].present?
      redirect_to root_path, :alert => "Session Expired!!!. Login to continue..." and return
    end
  end

  def get_ipaddress
    request.env['REMOTE_ADDR']
  end
=begin
  protected
  def _set_current_session
    # Define an accessor. The session is always in the current controller
    # instance in @_request.session. So we need a way to access this in
    # our model
    accessor = instance_variable_get(:@_request)

    # This defines a method session in ActiveRecord::Base. If your model
    # inherits from another Base Class (when using MongoMapper or similar),
    # insert the class here.
    ActiveRecord::Observer.send(:define_method, "session", proc {accessor.session})
  end
=end
end
