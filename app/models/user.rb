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

class User < ActiveRecord::Base
  SUPER_ADMIN_ROLE = 'superadmin'
  ADMIN_ROLE = 'admin'
  USER_ROLE  = 'user'

  has_secure_password

  attr_accessible :name, :email, :password, :password_confirmation,
                  :new_password, :new_password_confirmation

  attr_accessor   :attempts, :new_password, :new_password_confirmation, :current_user_id  

  #associations
  belongs_to :role

  before_destroy :disable_removing_admin
  before_create  :disable_new_user_by_default
  after_update   :log_user_updation
  after_update   :inform_user_if_account_is_blocked
  after_save     :log_user_creation

  default_scope where(:deleted_at  => nil)
  scope :ordered, order("active ASC, name ASC")

  #validations
  validates :name,     :presence => true,
                      :length => {:maximum => 50, :allow_blank => true }

  validates :email,    :presence => true,
                       :length => {:maximum => 150, :allow_blank => true},
                       :format => {:with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i,
                                   :allow_blank => true }

  validates :password, :presence => {:on => :create}, :confirmation => true,
                       :length => {:in => 6..50, :if => :password_present?}

  
  validate :validate_email
  validates :new_password, :presence => true, :confirmation => true , :if => :password_reset_token_present?

  def password_reset_token_present?
    password_reset_token_was.present?
  end

  def self.users_list_for(current_user)
    arel  = joins(:role).where('users.id NOT IN(?)', current_user.id)
    case current_user.role.name
      when ADMIN_ROLE
        arel  = arel.where("roles.name like ?", USER_ROLE)
      when SUPER_ADMIN_ROLE
        arel  = arel.where("roles.name in(?)", [USER_ROLE, ADMIN_ROLE])
      else
        arel  = arel.where("roles.id < 1")
      end
    arel.ordered("active, name").
         select("users.id as id, users.name, email, last_login, active, roles.name as role_name")
  end

  def self.authenticate(email, password)
    email     = email.to_s.strip 
    password  =  password.to_s.strip 
    return 'Enter valid email to continue ...' unless email.match(/^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i) or email.nil? 
    return 'Enter password to continue ...' unless password.present?

    user = User.find_by_email(email.strip)
    return 'Invalid login !!!' if user.nil? or user.active == false

    unless user.authenticate(password.strip)
      msg = 'Invalid login !!!'
      invalid_count = user.invalid_attempts.to_i + 1
      user.update_attribute(:invalid_attempts, invalid_count)
      if invalid_count >= 10
        msg = 'Your account is blocked!.You will receive activation email if your account is active.'
        return msg if user.deactivate_account
      end
      msg
    else
      user.update_attribute(:invalid_attempts, 0)
      user.update_attribute(:last_login, Time.now)
      user
    end
  end

  def self.send_password_reset_mail_and_entry_to_auditlog(email,ipaddress=nil)
    email = email.strip
    return 'Enter valid email to continue ...' unless email.match(/^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i) or email.nil?

    user = User.find_by_email(email)
    if user && user.active == true
      user.send_password_reset_mail
      user.entry_to_auditlog_table(ipaddress)
      user
     else
      msg = "You will receive password reset mail if your email exist in our database and your account is active."
      return msg
    end
  end

  def self.find_user_by_password_reset_token(token,password)
      user = User.find_by_password_reset_token!(token)
      password = password.strip
      return user unless password.present?

      if user.password_reset_sent_at < 20.minutes.ago
         msg = "Reset password link is expired."
         return msg
      else
         user.update_attribute('password',password)
         user.clear_password_reset_token
         msg = "Password has been reset."
         return msg
      end
  end

  def deactivate_account
    self.active = false
    self.activation_key = SecureRandom.urlsafe_base64
    self.save
    true
  end

  #instance methods
  def super_admin?
    role.name == SUPER_ADMIN_ROLE
  end

	def send_mail(set,user)
		update_attribute(:active, set)
		UserMailer.confirm_email(user).deliver
	end

  def log_user_creation
    Auditlog.log_message(self.current_user_id, "User creation",
        "new user '#{self.name}'<#{self.email}> is created",
        self.to_json) if self.new_record?
  end

  def log_user_updation
    if self.email_changed? || self.password_digest_changed?
      UserMailer.updated_email(self).deliver

      Auditlog.log_message(self.current_user_id,
                           "User account Changes",
                           "User '#{self.name}'<#{self.email}> account is changed",
                           self.changes.to_json)
    end
    if self.active_changed?
      #UserMailer.confirm_email(self).deliver
      #log.to_json
      s = self.active
      Auditlog.create(  :task_type=>"User Activation",
                              :task_description => "User '#{self.name}'<#{self.email}> account is Activated",
                              :task_detail =>"user activation" ,:user_id => self.current_user_id)  if s==true
      Auditlog.create(  :task_type=>"User Deactivation",
                              :task_description => "User '#{self.name}'<#{self.email}> account is Deactivated",
                              :task_detail => "user deactivation", :user_id => self.current_user_id)  if s==false
    end
    true
  end

  #TODO: add email to queue
=begin
  def inform_user_if_account_is_blocked
    if self.activation_key_changed? and self.activation_key.present? and self.active == false
      UserMailer.unblock_user(self).deliver
      Auditlog.log_message(0, 'Multiple invalid login attempts',
          "Blocked user #{self.name}<#{self.email}> due to multiple Invalid login attempt",
           "{:email => #{self.email}, :user_id => #{self.id}, :client_ip => #{$ip}}")
    end
  end
=end
  def inform_user_if_account_is_blocked
    if self.activation_key_changed? and self.activation_key.present? and self.active == false
      UserMailer.unblock_user(self).deliver
      @log_message = {:task_type => 'Multiple invalid login attempts', 
                :task_description => "Blocked user #{self.name}<#{self.email}> due to multiple Invalid login attempt",
              :task_detail =>  ActiveSupport::JSON.encode({:email => self.email, :user_id => self.id,
                                                  :clien_ip => $ip })}
    end
  end

  def audit_log_message
    @log_message
  end

  def disable_new_user_by_default
    if self.new_record?
      self.active  = false
      self.role_id = role_id.present? ? role.id : Role.find_by_name(User::USER_ROLE).id
    end
    true
  end

  #private
  def validate_email
    unless email.blank? and errors[:email].present?
      arel =  User.where("LOWER(email) LIKE ?", email.to_s.downcase)
      if self.new_record?
        count = arel.count
      else
        count = arel.where("id NOT IN (?)", self.id).count
      end
      errors[:email] << 'has already been taken' if count > 0
    end
  end

  # For security purpose always disable user account on generation
  # Let admin to enable an user account
  def disable_removing_admin
    errors.add :base, "Administrator account cannot be removed" and return false if super_admin?
  end

  def send_password_reset_mail
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    self.save!
    UserMailer.password_reset(self).deliver
  end

  def clear_password_reset_token
    self.update_attribute(:password_reset_token, nil)
    self.update_attribute(:password_reset_sent_at, nil)
    return true
  end

  def entry_to_auditlog_table(ipaddress)
      Auditlog.log_message(0, "Reset Password", "Password reset info sent to #{self.name} {#{self.email}",
                              "Reset password info  email #{self.email} userid #{self.id} client IP #{ipaddress}")
  end

  def update_user(user)
    if self.respond_to?(:password_reset_sent_at)
      if self.password_reset_sent_at < 20.minutes.ago
        return 1
      else
        self.clear_password_reset_token
        self.update_attributes(:password => user[:new_password])
        return 2
      end
    end
  end

  def update_user_activation_key
    self.update_attribute('activation_key','')
    self.update_attribute('invalid_attempts',0)
    self.update_attribute('active', true)
  end

  def destroy
    self.active     = false
    self.deleted_at =  Time.now.to_s
    self.save
  end
  #protected
  def email_not_present?
    return true unless email.present?
  end

  def password_present?
    self.password.to_s.strip.present?
  end
end
