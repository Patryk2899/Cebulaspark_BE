class UserMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default template_path: 'users/mailer'

  def reset_password_instructions(user)
    mail(to: user.email, subject: 'Welcome to the New Site')
  end
end
