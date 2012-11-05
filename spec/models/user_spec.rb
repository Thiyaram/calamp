# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(50)       not null
#  email                  :string(150)      not null
#  password_digest        :string(255)      not null
#  role_id                :integer          not null
#  active                 :boolean          default(FALSE), not null
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  deleted_at             :datetime
#  activation_key         :string(32)
#  invalid_attempts       :integer
#  last_login             :datetime
#

require 'spec_helper'

describe User do

	let(:super_admin) {Role.find_or_create_by_name("superadmin")}
	let(:admin_role) {Role.find_or_create_by_name("admin")}
	let(:user_role) {Role.find_or_create_by_name("user")}
	
 def create_user
	@user ||= User.new(:name => 'stevemartin', :email => 'thiyaram@example.com', 
				:password => 'password', :password_confirmation => 'password')
	@user.role_id = user_role.id
	@user.current_user_id = 
	@user.save 		

	@superadmin ||= User.new(:name => 'superadmin', :email => 'superadmin@example.com', 
				:password => 'password', :password_confirmation => 'password')
	@superadmin.role_id = super_admin.id
	@superadmin.save 		

	@admin ||= User.new(:name => 'admin', :email => 'admin@example.com', 
				:password => 'password', :password_confirmation => 'password')
	@admin.role_id = admin_role.id
	@admin.save 		
 end	

  before do 
  	create_user
  end

  context "assignment" do
	it { should allow_mass_assignment_of(:name)                                       }
	it { should allow_mass_assignment_of(:email)                                      }
	it { should allow_mass_assignment_of(:password)                                   }
	it { should allow_mass_assignment_of(:password_confirmation)                      }
	it { should_not allow_mass_assignment_of(:updated_at)                             }
	it { should_not allow_mass_assignment_of(:active)                                }
	it { should_not allow_mass_assignment_of(:role_id)                                }
	it { should_not allow_mass_assignment_of(:created_at)                             }
 end

context "Validation" do
	it { should validate_presence_of(:name)                                            }
	it { should ensure_length_of(:name).is_at_most(50)                                 }
	it { should validate_format_of(:name).with('stevemartin')                          }

	it { should validate_presence_of(:email)                                          }
	it { should validate_format_of(:email).with('thiyaram@example.com')               }
	it { should validate_uniqueness_of(:email)                                        }
	it { should validate_presence_of(:password)                                       }
	it { should validate_confirmation_of(:password)                                   }
	end

context "Instance methods" do

	it "should allow only superadmin to change user role" do
		@user.current_user_id = @superadmin.id
    	@user.role_id 		  = admin_role.id
    	@user.save.should be_true
    end

	it "should  not allow other users except superadmin to change user role" do
		@user.current_user_id = [@admin.id, @user.id].sample
    	@user.role_id 		  = admin_role.id
    	@user.save.should be_false
    end
  
  it " should set default attributes " do
    	user = User.new(:name => 'stevemartin', :email => 'thiyaram@example.com', 
				:password => 'password', :password_confirmation => 'password')    	    	
      	user.set_default_attributes
      	user.save.should be_false      	   
	end
	it " should Not set default attributes for updating user" do
		@user.set_default_attributes
		@user.save.should be_true
	end
  
end  
  # test that the callback is called...
  describe 'after_save' do
    it "creates a log_user_creation" do
      expect {
		@user = User.new(:name =>' ram', :email => 'thiyram@example.com', :password => 'password', :password_confirmation => 'password')
		@user.set_default_attributes  	
		@user.save.should be_true 	
	
      }.to change{ Auditlog.all.count }.by(1)     
      Auditlog.last.task_type.should eq "User creation"	
    end

     it "creates a log_user_updation" do
      expect {
		@user ||= User.last		
		@user.email = 'thiyaram77@gmail.com'
		@user.email_changed?.should be_true
		@user.update_attribute(:email, 'thiyaram77@gmail.com')
		Auditlog.last.task_type.should eq "User account Changes"		 	

	 }.to change{ Auditlog.count }.by(1) 

	end
	it "creates a log_user_updation" do
	 expect {
		@user.active = true
		@user.active_changed?.should be_true
		@user.update_attribute(:active, true)
		Auditlog.last.task_type.should eq "User Activation"	
		@user.active = false
		@user.active_changed?.should be_true
		@user.update_attribute(:active, false)
		Auditlog.last.task_type.should eq "User Deactivation"			
      }.to change{ Auditlog.count }.by(2) 
    end

  end

  describe "Delete a record" do
	it "New user can create an account using email"		do
		@user = User.new(:name =>' ram', :email => 'thiy@example.com', :password => 'password', :password_confirmation => 'password')
		@user.set_default_attributes  	
		@user.save.should be_true 
		@user = User.new(:name =>' ramkumar', :email => 'thiy@example.com', :password => 'password', :password_confirmation => 'password')
		@user.set_default_attributes  			
		@user.save.should be_false 
		user = User.last		
		user.email = 'thiyaram@example.com'
		user.save.should be_false
		#@user.errors[:email].should have(1).error_on(:email) 
		@user.errors[:email].should include('has already been taken')
  	end	
   end

   describe " If delete the recore set deleted_at field value" do
   	it "The record is deleted than override the delete method" do
   		user = User.last.delete
   		user.destroy.should be_true
   		user.active.should eq false
   		user.deleted_at.should_not be_nil
   	end
   end

	 
  context "class methods" do
  	before(:each) do
      	@user = FactoryGirl.create(:user)
      end

  	describe ".authenticate" do

  		it "should return invalid login message if user does not exist" do
  			@user.email = nil
  			@user = User.find_by_email(@user.email)
        @user.should be_nil
  		end	

  		it "should redirect to devices page if user is exist and active is true" do
  			@user = User.find_by_email(@user.email)
  			@user.authenticate(@user.password)
 				@user.should be_true
  		end
  	end

  	describe ".send_password_reset_mail_and_entry_to_auditlog(email,ipaddress=nil)" do

  		it "should return You will receive password reset mail if your email exist in our database and your account is active." do
  			@user.active = true
  			@user.save!
  			@user = User.send_password_reset_mail_and_entry_to_auditlog(@user.email,'127.0.0.1')
  			@user.should eq('You will receive password reset mail if your email exist in our database and your account is active.')
  		end	
  	end

  	describe ".find_user_by_password_reset_token(token,password)" do

  		it "should show reset password link is expired when password_reset_sent_at less than 20 minutes" do
  			@user.password_reset_token = SecureRandom.urlsafe_base64
  			@user.password_reset_sent_at = 20.minutes.ago
  			@user.save!
  			@user = User.find_user_by_password_reset_token(@user.password_reset_token,@user.password)
  			@user.should eq('Reset password link is expired.')
  		end

  		it "should show password has been reset if password_reset_sent_at not less than 20 minutes" do
  			@user.password_reset_token = SecureRandom.urlsafe_base64
  			@user.password_reset_sent_at = 15.minutes.ago
  			@user.save!
  			@user = User.find_user_by_password_reset_token(@user.password_reset_token,@user.password)
  			@user.should eq('Password has been reset.')
  		end
  	end
	end


  context "instance methods" do
  	before(:each) do
      	@user = FactoryGirl.create(:user)
      end

    describe "#password_reset_token_present?" do

      it "should return true when password_digest present" do
      	@user.password_digest.should be_true
      end

	  	it "should check password_reset_token present" do
	  		@user.password_digest = nil
	  		@user.password_reset_token.should be_nil
	  	end
		end

		describe "#deactivate_account" do

			it "return invalid login for user who is deactivated" do
				@user.deactivate_account
				@user.active.should be_false
			end
		end

		describe "#send_password_reset_mail" do

			it "should set activation key for the user who is blocked" do
				@user.send_password_reset_mail
				@user.password_reset_token.should be_true
			end	

		end

		describe "#inform_user_if_account_is_blocked" do
		
			it "should made entry to auditlog table when user's account is blocked" do
				@user.activation_key = SecureRandom.urlsafe_base64
				@user.active = false
				@user.inform_user_if_account_is_blocked
				Auditlog.all.count.should eq(1)
			end

			it "should not made entry to auditlog table when user's active false" do
 				@user.activation_key = nil
 				@user.active = true
 				@user.inform_user_if_account_is_blocked
 				Auditlog.all.count.should eq(0)
			end

		end	

		describe "#entry_to_auditlog_table" do

			it "should made entry to auditlog table" do
				user = User.new
				user.password_reset_token = SecureRandom.urlsafe_base64
				user.entry_to_auditlog_table('127.0.0.1')
				Auditlog.all.count.should eq(1)
			end
		end

		describe "#clear_password_reset_token" do

			it "should return nil for password_reset_token" do
				@user.password_reset_token = SecureRandom.urlsafe_base64
				@user.password_reset_sent_at = Time.now
				@user.clear_password_reset_token
				@user.password_reset_token.should be_nil
			end
		end

		describe "#update_user(user)" do
			it "should return 1 when password_reset_sent_at is 20 minutes ago" do
				@user.password_reset_token = SecureRandom.urlsafe_base64
				@user.password_reset_sent_at = 20.minutes.ago
				@user.update_user(@user)
				@user.password_reset_sent_at.should eq(@user.password_reset_sent_at)
			end
		end

		describe "#update_user_activation_key" do

			it "should return activation key nil" do
				@user.activation_key = SecureRandom.urlsafe_base64
				@user.invalid_attempts = 10
				@user.active = false
				@user.update_user_activation_key
				@user.activation_key.should eq("")
			end
		end
	end
end


	


