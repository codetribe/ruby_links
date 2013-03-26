ActionMailer::Base.smtp_settings = {
  :address              => "smtp.zoho.com",
  :port                 => 465,
  :user_name            => APP_CONFIG["email"],
  :password             => APP_CONFIG["password"],
  :enable_starttls_auto => true
}
