require 'rails_helper'

RSpec.describe Users::UsersController, type: :controller do
  include ApiHelper

  describe 'Users spec' do
    let!(:basic_user) { create :user, :basic_email, :default_role, :random_password }

    it 'should update email' do
      authenticated_header(request, basic_user)
      new_email = 'new_email@test.pl'
      put :update_email, params: { email: new_email }

      expect(response).to have_http_status(:ok)
      expect(basic_user.reload.email).equal?(new_email)
    end

    it 'should not update email' do
      authenticated_header(request, basic_user)
      invalid_email = 'new_email'
      put :update_email, params: { email: invalid_email }

      expect(response).to have_http_status(:bad_request)
    end

    it 'should update password' do
      authenticated_header(request, basic_user)
      old_password = basic_user.encrypted_password
      put :update_password, params: { password: 'changed_password' }

      expect(response).to have_http_status(:ok)
      expect(basic_user.reload.encrypted_password != old_password).to be true
    end

    it 'should not update password' do
      authenticated_header(request, basic_user)
      old_password = basic_user.encrypted_password
      put :update_password, params: { password: 'new' }

      expect(response).to have_http_status(:bad_request)
      expect(basic_user.encrypted_password != old_password).to be false
    end

    it 'should pass password check' do
      authenticated_header(request, basic_user)
      post :check_password, params: { password: 'random_password' }

      expect(response).to have_http_status(:ok)
    end

    it 'should not pass password check' do
      authenticated_header(request, basic_user)
      post :check_password, params: { password: 'invalid_password' }

      expect(response).to have_http_status(:bad_request)
    end
  end
end
