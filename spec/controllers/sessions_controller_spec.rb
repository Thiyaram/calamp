require 'spec_helper'

describe SessionsController do
  before(:all) do
    Role.destroy_all
    User.destroy_all
    ['user','admin','superadmin'].each do |x|
      role = Role.find_or_create_by_name(x)
      user = User.new(:email => "#{x}@example.com", :password => 'password',
                      :password_confirmation => 'password', :name => 'test')
      user.role_id =  role.id
      user.save
      user.active = true
      user.save
    end
  end

  let(:admin) { @admin ||=  User.find_by_email("admin@example.com") }
  let(:superadmin) { @superadmin ||=  User.find_by_email("superadmin@example.com") }
  let(:user) { @user ||=  User.find_by_email("user@example.com") }


  shared_examples_for "user" do
    it "should render new page" do
      get 'new'
      response.should render_template('new')
    end

    describe " POST create" do
      it "create a new session and redirect to devices path" do
        post :create, valid_attributes, {}
        response.should redirect_to(admin_devices_path)
        session[:user_id].should eql current_user_session_id
      end

      it "re-renders the 'new' template for invalid params" do
        post :create, {:email => valid_attributes[:email], :password => 'passwd'}, {}
        response.should render_template("new")
        flash[:alert].should match 'Invalid login !!!'
      end

      it "should block user account after 10 contineous invalid attempts" do
        reset_user_account
        10.times do
          post :create, {:email => valid_attributes[:email], :password => 'passwd'}, {}
        end
        response.should render_template("new")
        flash[:alert].should match 'Your account is blocked!.You will receive activation email if your account is active.'
      end

      it "should show invalid login message for blocked accounts" do
        reset_user_account
        11.times do
          post :create, {:email => valid_attributes[:email], :password => 'passwd'}, {}
        end
        response.should render_template("new")
        flash[:alert].should match 'Invalid login !!!'
      end

    end

    describe "Logout" do
      it "destroys the current user session" do
        delete :destroy, {}, valid_session
        session[:user_id].should be_nil
      end

      it "redirects to the root path" do
        delete :destroy, {}, valid_session
        response.should redirect_to(login_url)
      end
    end
  end

  context "Superadmin Role" do

    def valid_attributes
      {:email => "superadmin@example.com", :password => 'password'}
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

    include_examples "user"
  end

  context "Admin Role" do
     def valid_attributes
      {:email => "admin@example.com", :password => 'password'}
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
    include_examples "user"
  end

  context "User Role" do
     def valid_attributes
      {:email => "user@example.com", :password => 'password'}
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
    include_examples "user"
  end

  context "Guest role" do
    def valid_attributes
      {:email => "guest@example.com", :password => 'password'}
    end

    it "should render new page" do
      get 'new'
      response.should render_template('new')
    end

    it "re-renders the 'new' template" do
      post :create, valid_attributes, {}
      response.should render_template("new")
      flash[:alert].should match 'Invalid login !!!'
    end
  end

end
