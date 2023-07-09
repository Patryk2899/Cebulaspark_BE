require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :controller do
  describe 'POST /password' do
    let!(:basic_user) { create :user, :basic_email, :default_role, :random_password }
    it 'creates and sends reset token' do
      post :create, params: { email: basic_user.email }
      expect(response).to have_http_status(:success)
      expect(basic_user.reload.reset_password_token).to be_present
    end
  end

  describe 'PUT /password' do
    let!(:basic_user) do
      create :user, :basic_email, :default_role, :random_password, :reset_password_token1, :reset_password_sent_at
    end
    it 'updates password with success' do
      put :update,
          params: { reset_password_token: basic_user.reset_password_token, password: 'test123',
                    password_confirmation: 'test123' }
      expect(response).to have_http_status(:success)
    end
  end
end
