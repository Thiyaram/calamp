require 'spec_helper'

describe PasswordResetsController do
  before(:all) do
    Role.destroy_all
    User.destroy_all
    ['user','admin','superadmin'].each do |x|
      role = Role.find_or_create_by_name(x)
      user = User.new(:email => "#{x}@example.com", :password => 'password', 
                      :password_confirmation => 'password', :name => 'test')
      user.role_id =  role.id      
      user.save
      user.password_reset_token =  SecureRandom.urlsafe_base64
      user.password_reset_sent_at = Time.now
      user.active = true      
      user.save
    end
  end

  let(:admin) { @admin ||=  User.find_by_email("admin@example.com") }
  let(:superadmin) { @superadmin ||=  User.find_by_email("superadmin@example.com") }
  let(:user) { @user ||=  User.find_by_email("user@example.com") }


  shared_examples_for "passwordresets" do
    describe "GET new" do
      it "should render new page" do
        get 'new'
        response.should render_template('new')
      end
    end

    describe "POST create" do
      it "render new and get confirmation message for reset password when email is available in our database" do
        post :create, valid_attributes, {}
        response.should redirect_to(new_password_reset_path)
        flash[:notice].should match 'You will receive password reset mail if your email exist in our database and your account is active.'
      end

      it "render new and get confirmation message for reset password when email not is available in our database" do
        post :create, valid_attributes, {}
        response.should redirect_to(new_password_reset_path)
        flash[:notice].should match 'You will receive password reset mail if your email exist in our database and your account is active.'
      end

      it "re-renders the 'new' template for invalid email" do
        post :create, {:email => 'test'}, {}
        response.should render_template('new')
        flash[:notice].should match 'Enter valid email to continue ...'
      end
    end

    describe "GET edit" do
      it "should render edit page" do
        get 'edit', {:id => valid_attributes[:password_reset_token].to_param}, {}
        response.should render_template('edit', :id => valid_attributes[:password_reset_token])
      end
    end

    describe "PUT update" do
      it "should redirect to new when password has been reset" do
        put :update, {:user => {:new_password => 'password', :new_password_confirmation => 'password'}, :id => valid_attributes[:password_reset_token].to_param}, {}
        response.should redirect_to(new_password_reset_path)
        flash[:notice].should match 'Password has been reset.'
      end

      it "should render edit when password has not been reset" do
        put :update, {:user => {:new_password => '', :new_password_confirmation => ''}, :id => valid_attributes[:password_reset_token].to_param}
        response.should render_template('edit')
        flash[:alert].should match "New password can't be blank"
      end

      it "should render edit when password has not been reset" do
        put :update, {:user => {:new_password => 'password', :new_password_confirmation => 'passwrd'}, :id => valid_attributes[:password_reset_token].to_param}
        response.should render_template('edit', :id => valid_attributes[:password_reset_token].to_param)
        flash[:alert].should match ''
      end

      it "should render new and show message password reset link has expired" do
        user.update_attribute('password_reset_sent_at', 20.minutes.ago)
        admin.update_attribute('password_reset_sent_at', 20.minutes.ago)
        superadmin.update_attribute('password_reset_sent_at', 20.minutes.ago)
        put :update, {:user => {:new_password => 'password', :new_password_confirmation => 'password'}, :id => valid_attributes[:password_reset_token].to_param}
        response.should redirect_to(root_url)
        flash[:alert].should match 'Reset password link is expired.'
      end
    end
  end

  context "Superadmin Role" do
     def valid_attributes
      {:email => "superadmin@example.com", :password_reset_token => superadmin.password_reset_token, :password_reset_sent_at => Time.now }
    end

    def current_user_session_id
      superadmin.id
    end

    def valid_session
      {:user_id => current_user_session_id }
    end

    def reset_user_account
      superadmin.active = true
      superadmin.invalid_attempts = 0
      superadmin.activation_key = nil
      superadmin.save
    end
    include_examples "passwordresets"
  end

  context "Admin Role" do
     def valid_attributes
      {:email => "admin@example.com", :password_reset_token => admin.password_reset_token, :password_reset_sent_at => Time.now }
    end

    def current_user_session_id
      admin.id
    end

    def valid_session
      {:user_id => current_user_session_id }
    end

    def reset_user_account
      admin.active = true
      admin.invalid_attempts = 0
      admin.activation_key = nil
      admin.save
    end
    include_examples "passwordresets"
  end

  context "User Role" do
     def valid_attributes
      {:email => "user@example.com", :password_reset_token => user.password_reset_token, :password_reset_sent_at => Time.now}
    end

    def current_user_session_id
      user.id
    end

    def valid_session
      {:user_id => current_user_session_id }
    end

    def reset_user_account
      user.active = true
      user.invalid_attempts = 0
      user.activation_key = nil
      user.save
    end
    include_examples "passwordresets"
  end
end

