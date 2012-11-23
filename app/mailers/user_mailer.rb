class UserMailer < ActionMailer::Base
  default from: EmailConfig.from, cc: EmailConfig.cc

  def unblock_user(user)
		@user = user
 		mail :to => user.email, 
 				 :subject => 'Alert: Account disabled due to more than 10 unsuccessful attempts'
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => 'Password reset information'
  end

	def confirm_email(user)
    @user = user
		mail(:to => user.email, :subject =>  user.active == true ? "Your account is Activated" : "Your account is Deactivated", 
          :content_type => "multipart/alternative" )
  end

	def updated_email(user)
    @user = user    
    mail(:to => user.email, :subject => "Your updated login credentails", :content_type => "multipart/alternative" )
  end

end

