require 'rails_helper'

describe UserMailer do
  describe 'password_reset' do
    let!(:basic_user) { create :user, :basic_email, :default_role, :random_password }
    it 'sends email with password reset link' do
      expect do
        UserMailer.reset_password_instructions(basic_user).deliver_later(wait: 10.seconds)
      end.to have_enqueued_job(ActionMailer::MailDeliveryJob)
    end
  end
end
