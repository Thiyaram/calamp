require "spec_helper"

describe UserMailer do
  def create_user
    user = User.new(:name => 'stevemartin', :email => Faker::Internet.email, 
                     :password => 'password', :password_confirmation => 'password')
    user.role_id = Role.find_or_create_by_name('user').id
    user.save    
    user
  end  

  describe "Block user when invalid attempts crosses 10" do
    before (:all) do
      @user = create_user
      @user.deactivate_account
      @mail  = UserMailer.unblock_user(@user).deliver 
    end

		it "should send email to correct user " do 
      @mail.to.should include @user.email 
      @mail.cc.should include EmailConfig.cc
      @mail.subject.should eq 'Alert: Account disabled due to more than 10 unsuccessful attempts'
      @mail.content_type.should eq 'text/html; charset=UTF-8'
    end
	end

  describe "Password Reset" do
    before(:all) do
      @user = create_user  
      @mail  = @user.send_password_reset_mail
    end

    it "should send email to correct user " do 
      @mail.to.should include @user.email 
      @mail.cc.should include EmailConfig.cc
      @mail.subject.should eq 'Password reset information'
      @mail.content_type.should eq 'text/html; charset=UTF-8'   
    end
  end
end
