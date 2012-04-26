require 'tlsmail'
Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "soobooki.com",
  :user_name            => "honki91@gmail.com",
  :password             => "ahddlhong10",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
