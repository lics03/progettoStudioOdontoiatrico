class UserMailer < ActionMailer::Base
  
  default from: "progettoarchitetture@gmail.com"
  #layout 'mailer'
  
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end