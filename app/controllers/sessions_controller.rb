class SessionsController < ApplicationController
  #force_ssl
  skip_before_filter :check_session, :except => [:destroy]

  layout 'login'

  def new
  end

  def create
    $ip = get_ipaddress
    @user = User.authenticate(params[:email], params[:password])
    msg = @user
    unless @user.respond_to?(:name)
      flash.now.alert = msg
      render "new" and return
    end
    session[:user_id]  =  @user.id
    redirect_to admin_devices_url, notice: "Logged in!", only_path: true
  end

  def edit
    user = User.find_by_activation_key(params[:id])
    user.update_user_activation_key
    flash.now.notice = "Account activated successfully.Login to continue..."
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, :notice => "Successfully logged out"
  end

end
