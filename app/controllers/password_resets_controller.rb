class PasswordResetsController < ApplicationController
#filters
skip_before_filter:session_expiration

layout 'login'

  def new
  end

  def create
    ip = get_ipaddress
    user = User.send_password_reset_mail_and_entry_to_auditlog(params[:email],ip)
    msg  = user
    if user.respond_to?(:name)
      redirect_to new_password_reset_path, :notice => "You will receive password reset mail if your email exist in our database and your account is active."   
    else
      flash.now.notice = msg
      render 'new'
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token(params[:id])    
    new_password = params[:user][:new_password].strip
    new_password_confirmation = params[:user][:new_password_confirmation].strip
    unless new_password.present?
      redirect_to "/password_resets/#{@user.password_reset_token}/edit", :alert => "Enter password to continue ..."  and return
    end
    unless new_password == new_password_confirmation
        redirect_to "/password_resets/#{@user.password_reset_token}/edit", :alert => "password  does not match confirmation..." and return
    end 
    msg = @user.update_user(params[:user])
    if msg == 1
      redirect_to  "/", :alert => "Reset password link is expired."
    elsif msg == 2
      redirect_to new_password_reset_path, :notice => "Password has been reset."
    else
      redirect_to "/password_resets/#{user.password_reset_token}/edit", :alert => "Enter password ..."
    end
  end

end





