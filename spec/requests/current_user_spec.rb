require 'rails_helper'

RSpec.describe CurrentUserController, type: :controller do
  describe 'GET /index' do
    let!(:basic_user) { create :user, :basic_email, :default_role, :random_password }
    it 'returns http success' do
      sign_in(basic_user)
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
