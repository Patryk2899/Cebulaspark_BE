require 'rails_helper'

RSpec.describe CurrentUserController, type: :controller do
  include ApiHelper
  describe 'GET /index' do
    let!(:basic_user) { create :user, :basic_email, :default_role, :random_password }
    it 'returns http success' do
      authenticated_header(request, basic_user)
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
