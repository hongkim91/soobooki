class UserMailer < ActionMailer::Base
  default from: "honki91@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Soobooki.com: Password Reset!"
  end
  def email_confirmation(user)
    @user = user
    mail :to => user.email, :subject => "Soobooki.com: Email Confirmation!"
  end
end
