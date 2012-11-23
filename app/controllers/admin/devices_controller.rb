class Admin::DevicesController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:destroy]
  before_filter :check_role, :except => :index

  def index
    @devices = currentuser::Device.all
  end
 
  def show
    @device = Device.find(params[:id])
    @device = @device.change_status
    if @device.status == true
      redirect_to admin_devices_url,  :notice => 'Device activated successfully.'
    else
      redirect_to admin_devices_url,  :notice => 'Device deactivated successfully.'
    end
  end

  def new
    @device = Device.new
  end
  
  def edit
    @device = Device.find(params[:id])
  end

  def create
    @device = Device.new(params[:device])
    if @device.save
      redirect_to admin_devices_url, notice: 'Device was successfully created.'
    else
      render "new" 
    end
  end

  def update
    @device = Device.find(params[:id])
    if @device.update_attributes(params[:device])
       redirect_to admin_devices_path, only_path:true,  notice: 'Device was successfully updated.' 
    else
     render "edit" 
    end
  end

  def destroy
    @device = Device.find(params[:id])
    @device.destroy
    redirect_to admin_devices_url, :notice => 'Device removed successfully'       
  end

  def check_role
    if current_user.role.name == 'user'
      redirect_to admin_devices_path, :alert => 'You cannot have this access permission!!!' 
    end
  end

	def currentuser	
 		Superadmin if  current_user.role.name == 'superadmin'
 		Admin 		 if  current_user.role.name == 'admin'
 		Normaluser if  current_user.role.name == 'user'
	end
end
