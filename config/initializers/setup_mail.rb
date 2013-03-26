ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :user_name            => APP_CONFIG["email"],
  :password             => APP_CONFIG["password"],
  :authentication		=> "plain",
  :enable_starttls_auto => true
}
