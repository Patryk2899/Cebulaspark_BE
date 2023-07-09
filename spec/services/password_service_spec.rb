require 'rails_helper'

RSpec.describe PasswordService, type: :model do
  describe 'password service test' do
    let!(:basic_user) { create :user, :basic_email, :default_role, :random_password }
    let!(:password_reset_user_obsolete) do
      create :user, :test_email1, :default_role,
             :random_password, :reset_password_token1, :reset_password_sent_at_minus_four_days
    end
    let!(:password_reset_user) do
      create :user, :test_email2, :default_role, :random_password,
             :reset_password_token2, :reset_password_sent_at
    end
    it 'send_password_change_request sends email' do
      expect do
        PasswordService.new.send_password_change_request(basic_user.email)
      end.to have_enqueued_job(ActionMailer::MailDeliveryJob)
    end

    it 'send_password_change_request do not sends email - invalid email' do
      expect do
        PasswordService.new.send_password_change_request('no such email')
      end.to_not have_enqueued_job(ActionMailer::MailDeliveryJob)
    end

    it 'update_password succes' do
      result = PasswordService.new.update_password(password_reset_user.reset_password_token, 'password', 'password')
      expect(result).to eq(200)
    end

    it 'update_password failed' do
      result = PasswordService.new.update_password(password_reset_user_obsolete.reset_password_token, 'password',
                                                   'password')
      expect(result).to eq(401)
    end
  end
end
