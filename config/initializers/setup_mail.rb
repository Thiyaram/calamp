ActionMailer::Base.smtp_settings = {
  :address              => "smtp.example.com",  
  :port                 => 587,  
  :domain               => "example.com",  
  :user_name            => "ClampListener",  
  :password             => "secret",  
  :authentication       => "plain",  
  :enable_starttls_auto => true  
}  
