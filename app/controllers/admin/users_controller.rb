class Admin::UsersController < ApplicationController

  def index
    #@users = User.all
    @users = User.users_list_for(current_user)
  end

  def new
    @user = User.new
  end

  def create
    @user                 = User.new(params[:user])
    @user.current_user_id = current_user.id
    @user.role_id         =  params[:role_id]  if current_user.role.name == User::SUPER_ADMIN_ROLE
    if @user.save
      redirect_to admin_users_url, notice: 'User was successfully created.'
    else
      flash.now.alert = @user.errors[:base].to_sentence if @user.errors[:base].present?
      render "new"
    end
  end

  def show
    @user      = User.find(params[:id])
    @user.current_user_id = current_user.id
		@user.send_mail(params[:active],@user)if params[:active].present?
		redirect_to admin_users_url
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
      @user = User.find(params[:id])
      restore_user_id_unless_super_admin
      @user.current_user_id = current_user.id
      if @user.update_attributes(params[:user])
        redirect_to admin_users_url, notice: 'User profile updated successfully'
      else
        render 'edit'
      end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = 'User account is removed successfully'
    else
      flash[:alert] =  'Unable to remove user account. Try again !!!'
    end
    redirect_to admin_users_url
  end

  def restore_user_id_unless_super_admin
    if params[:user]['role_id']
      params[:user]['role_id'] =  @user.role_id unless super_admin?
    end
  end
end
