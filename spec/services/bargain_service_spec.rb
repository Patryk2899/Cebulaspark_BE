require 'rails_helper'

RSpec.describe BargainService, type: :model do
  describe 'bargain service test' do
    let!(:test_user) { create :user, :basic_email, :default_role, :random_password }
    let!(:electronic) { create :category, :electronics }
    let!(:home) { create :category, :home }
    let!(:health) { create :category, :health }

    it 'should create bargain' do
      params = { bargain: nil, category: nil }
      bargain = build(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                        category_ids: health.id)
      params[:bargain] = bargain.as_json.compact
      params[:category] = [health.as_json]
      expect(BargainService.new(params, test_user).create).to be :ok
    end

    it 'should not create bargain - no category' do
      params = { bargain: nil, category: nil }
      bargain = build(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                        category_ids: health.id)
      params[:bargain] = bargain.as_json.compact
      expect(BargainService.new(params, test_user).create).to be :bad_request
    end

    it 'should update bargain categories' do
      params = { bargain: nil, category: nil }
      bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                         category_ids: health.id)
      params[:bargain] = bargain.as_json
      params[:category] = [home.as_json, health.as_json]
      expect(BargainService.new(params, test_user).update).to be :ok
      expect(bargain.reload.categories.include?(health)).to be true
      expect(bargain.reload.categories.include?(home)).to be true
    end

    it 'should update bargain title' do
      params = { bargain: nil, category: nil }
      bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                         category_ids: health.id)
      title = 'new title'
      bargain.title = 'new title'
      params[:bargain] = bargain.as_json
      expect(BargainService.new(params, test_user).update).to be :ok
      expect(bargain.reload.title == title).to be true
    end

    it 'should not update bargain wrong id' do
      params = { bargain: nil, category: nil }
      bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                         category_ids: health.id)
      bargain.id = 0
      params[:bargain] = bargain.as_json
      expect(BargainService.new(params, test_user).update).to be :bad_request
    end

    it 'should not destroy bargain' do
      params = { bargain: nil, category: nil }
      bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                         category_ids: health.id)
      bargain.id = 0
      params[:bargain] = bargain.as_json
      expect(BargainService.new(params, test_user).destroy).to be :bad_request
    end

    it 'should destroy bargain' do
      params = { bargain: nil, category: nil }
      bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                         category_ids: health.id)
      params[:bargain] = bargain.as_json
      expect(BargainService.new(params, test_user).destroy).to be :ok
      expect(bargain.reload.active).to be false
    end
  end
end
