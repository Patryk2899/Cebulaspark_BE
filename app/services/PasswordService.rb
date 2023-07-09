# frozen_string_literal: true

class PasswordService
  def initialize; end

  def send_password_change_request(email)
    user = User.find_by_email(email)
    create_reset_password_token(user) if user
    user.reset_password_sent_at = Time.now if user
    UserMailer.reset_password_instructions(user).deliver_later(wait: 15.seconds) if user
  end

  def update_password(reset_token, password, password_confirmation)
    user = User.find_by(reset_password_token: reset_token)

    return 401 unless user
    return 401 unless user.reset_password_period_valid?
    return 401 unless user.reset_password(password, password_confirmation)

    200
  end

  private

  def create_reset_password_token(user)
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    @token = raw
    @user = user
    user.reset_password_token = hashed
    user.reset_password_sent_at = Time.now.utc
    user.save
  end
end
