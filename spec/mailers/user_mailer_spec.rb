require "spec_helper"

describe UserMailer do

  context "mailer's instance methods" do
  	before(:each) do
  		@user = FactoryGirl.create(:user)
  	end

  	describe "Block user" do
  		it "should sent email to the user who's invalid attempts crosses 10" do
	  		UserMailer.unblock_user(@user)
	  		it { should have_sent_email.with_subject('Alert: Account disabled due to more than 10 unsuccessful attempt') }
	  		it { should have_sent_email.from('Calamp Listener<from@example.com>') }
	  		it { should have_sent_email.to(@user.email) }
	  		it { should have_sent_email.with_part('text/html') }
  		end
  	end

  	describe "password reset mail" do
  		it "should sent email to the user who wants to reset their password" do
	  		UserMailer.password_reset(@user)
	  		it { should have_sent_email.with_subject('Password reset information') }
	  		it { should have_sent_email.from('Calamp Listener<from@example.com>') }
	  		it { should have_sent_email.to(@user.email) }
	  		it { should have_sent_email.with_part('text/html') }
  		end
  	end
  end	
end
