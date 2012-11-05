require 'spec_helper'

describe PasswordResetsController do

	describe "GET 'new'" do
    it "render new page" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do 
  	before do 
    	@user = FactoryGirl.create(:user, :password_reset_token => SecureRandom.urlsafe_base64, :password_reset_sent_at => 25.minutes.ago)
  	end

  	it "should throw record not found error when password reset token is not found" do 
  		user = User.find_by_password_reset_token!(@user.password_reset_token)
  		user.password_reset_sent_at = Time.now
  		user.save!
  		user = User.find_user_by_password_reset_token(@user.password_reset_token,@user.password)
  		user.should eq 'Password has been reset.'
  	end

  	it "should show message when password reset token has expired" do
  		user = User.send_password_reset_mail_and_entry_to_auditlog(@user.email)
  		user1 = User.find_user_by_password_reset_token(@user.password_reset_token, @user.password)
      user1.should eq	'Reset password link is expired.'
  	end	

  end

  describe "POST 'create'" do 
  	before do 
  		@user = FactoryGirl.create(:user)
  	end

  	it "should send email to the user if his email is in our database" do 
 			@user = User.send_password_reset_mail_and_entry_to_auditlog(@user.email)
 			@user.should eq 'You will receive password reset mail if your email exist in our database and your account is active.'
  	end

  	it "should not send email to the user if his email is not in our database" do 
	    @user.email = 'test@example.com'
	    @user = User.send_password_reset_mail_and_entry_to_auditlog(@user.email)
	 		@user.should eq 'You will receive password reset mail if your email exist in our database and your account is active.'
  	end

  	it "should show error message when user has given invalid email" do 
  		@user.email = 'test'
  		@user = User.send_password_reset_mail_and_entry_to_auditlog(@user.email)
	 		@user.should eq 'Enter valid email to continue ...'
  	end

  end

  describe "PUT 'update'" do 

  end

end

