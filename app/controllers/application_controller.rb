class ApplicationController < ActionController::Base
  #force_ssl
  protect_from_forgery

  before_filter :check_session
	helper_method :current_user

  def current_user
  	User.find(session[:user_id]) if session[:user_id].present?
  end

  def get_ipaddress
    request.env['REMOTE_ADDR']
  end

  def check_session
    request.session_options[:expire_after] = 15.minutes
    unless session[:user_id].present?
      flash.alert = "Session Expired!!!. Login to continue..."
      redirect_to "/"
    end
  end
end
