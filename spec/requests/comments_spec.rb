require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  include ApiHelper

  describe 'Comments controller test' do
    let!(:test_user) { create :user, :basic_email, :default_role, :random_password }
    let!(:another_user) { create :user, :default_role, :random_password, email: 'random@tset.pl' }
    let!(:electronic) { create :category, :electronics }
    let!(:home) { create :category, :home }
    let!(:health) { create :category, :health }
    it 'should fetch comments by bargain id' do
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      comment = create(:comment, :simple_body, :active, bargain_id: simple_bargain.id, user_id: test_user.id)
      get :show, params: { bargain_id: simple_bargain.id }

      expect(response).to have_http_status(:success)
      expect(response.body.size).equal?(1)
    end

    it 'should fetch empty array when there is no comments' do
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      get :show, params: { bargain_id: simple_bargain.id }

      expect(response).to have_http_status(:success)
      expect(response.body.size).equal?(0)
    end

    it 'should create comment' do
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      authenticated_header(request, test_user)
      expect do
        post :create, params: { bargain_id: simple_bargain.id, body: 'simple_body' }
      end.to change { Comment.count }.by(1)

      expect(response).to have_http_status(:success)
    end

    it 'should not create comment - lack of body' do
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      authenticated_header(request, test_user)
      expect do
        post :create, params: { bargain_id: simple_bargain.id }
      end.to change { Comment.count }.by(0)

      expect(response).to have_http_status(:bad_request)
    end

    it 'should update comment' do
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      authenticated_header(request, test_user)
      comment = create(:comment, :simple_body, :active, bargain_id: simple_bargain.id, user_id: test_user.id)
      post :update, params: { id: comment.id, body: 'new_body' }

      expect(response).to have_http_status(:success)
      expect(comment.reload.body).equal? 'new_body'
    end

    it 'should not update comment - invalid comment_id' do
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      authenticated_header(request, test_user)
      comment = create(:comment, :simple_body, :active, bargain_id: simple_bargain.id, user_id: test_user.id)
      post :update, params: { id: 0, body: 'new_body' }

      expect(response).to have_http_status(:bad_request)
    end

    it 'should destroy comment' do
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      authenticated_header(request, test_user)
      comment = create(:comment, :simple_body, :active, bargain_id: simple_bargain.id, user_id: test_user.id)
      delete :destroy, params: { id: comment.id }

      expect(response).to have_http_status(:ok)
      expect(comment.reload.deleted).to be true
    end

    it 'should not destroy comment - invalid id' do
      simple_bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                                category_ids: health.id)
      authenticated_header(request, test_user)
      comment = create(:comment, :simple_body, :active, bargain_id: simple_bargain.id, user_id: test_user.id)
      delete :destroy, params: { id: 0 }

      expect(response).to have_http_status(:bad_request)
      expect(comment.reload.deleted).to be false
    end
  end
end
