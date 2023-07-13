require 'rails_helper'

RSpec.describe BargainController, type: :controller do
  include ApiHelper

  describe 'Bargain controller test' do
    let!(:test_user) { create :user, :basic_email, :default_role, :random_password }
    let!(:another_user) { create :user, :default_role, :random_password, email: 'random@tset.pl' }
    let!(:electronic) { create :category, :electronics }
    let!(:home) { create :category, :home }
    let!(:health) { create :category, :health }

    it 'returns http success' do
      authenticated_header(request, test_user)
      simple_bargain = build(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                               category_ids: health.id).as_json
      post :create, params: { bargain: simple_bargain, category: [home.as_json, health.as_json] }
      expect(response).to have_http_status(:success)
    end

    it 'returns http bad_request on invalid params' do
      authenticated_header(request, test_user)
      simple_bargain = build(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                               category_ids: health.id)
      simple_bargain.user_id = 0
      post :create, params: { bargain: simple_bargain.as_json, category: [home.as_json, health.as_json] }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http success on update' do
      authenticated_header(request, test_user)
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      simple_bargain.title = 'new title'
      put :update, params: { bargain: simple_bargain.as_json, category: [home.as_json, health.as_json] }
      expect(response).to have_http_status(:success)
    end

    it 'returns http bad_request when user cannot access bargain' do
      authenticated_header(request, test_user)
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      simple_bargain.user_id = 0
      put :update, params: { bargain: simple_bargain.as_json, category: [home.as_json, health.as_json] }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http bad_request when params are invalid' do
      authenticated_header(request, test_user)
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      simple_bargain.title = ''
      put :update, params: { bargain: simple_bargain.as_json, category: nil }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns succes on destroy' do
      authenticated_header(request, test_user)
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      delete :destroy, params: { bargain: { id: simple_bargain.id }, category: nil }
      expect(response).to have_http_status(:ok)
    end

    it 'returns bad_request on destroy' do
      authenticated_header(request, another_user)
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      delete :destroy, params: { bargain: { id: simple_bargain.id }, category: nil }
      expect(response).to have_http_status(:ok)
    end
  end
end
