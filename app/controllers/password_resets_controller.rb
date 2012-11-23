class PasswordResetsController < ApplicationController
#filters
skip_before_filter:session_expiration
skip_before_filter:check_session

layout 'login'

  def new
  end

  def create
    ip = get_ipaddress
    user = User.find_by_email(params[:email])  rescue nil
    user.clear_password_reset_token if user.present?
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
    @user = User.find_by_password_reset_token!(params[:id]) 
    if @user.password_reset_sent_at < 20.minutes.ago
      redirect_to root_url, :alert => 'Reset password link is expired.'
    else 
      if @user.update_attributes(params[:user])
         @user.password = params[:user][:new_password]
         @user.clear_password_reset_token
         redirect_to new_password_reset_path, :notice => 'Password has been reset.'  
      else
        flash.now.alert = @user.errors.full_messages.to_sentence
        render 'edit'
      end  
    end
  end
end

=begin
    if @user.password_reset_sent_at <= 20.minutes.ago
      redirect_to root_url, :alert => 'Reset password link is expired.'
    else
      if @user.update_attributes(params[:user])
        @user.password = params[:user][:new_password]
        @user.clear_password_reset_token
        redirect_to new_password_reset_path, :notice => 'Password has been reset.'  
      else
        flash.now.alert = @user.errors.full_messages.to_sentence
        render 'edit'
      end  
    end
=end
