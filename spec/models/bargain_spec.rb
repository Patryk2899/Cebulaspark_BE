require 'rails_helper'

RSpec.describe Bargain, type: :model do
  let!(:test_user) { create :user, :basic_email, :default_role, :random_password }
  let!(:electronic) { create :category, :electronics }
  let!(:home) { create :category, :home }
  let!(:health) { create :category, :health }

  it 'should create bargain and set active' do
    bargain = build(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                      category_ids: home.id)
    expect(bargain.save).to be true
    expect(bargain.active).to be true
  end

  it 'should not create bargain - invalid link' do
    bargain = build(:bargain, :short_description, :not_obsolete, :invalid_link, :title, user_id: test_user.id,
                                                                                        category_ids: home.id)
    expect(bargain.save).to be false
  end

  it 'should not create bargain - no title' do
    bargain = build(:bargain, :short_description, :not_obsolete, :valid_link, user_id: test_user.id,
                                                                              category_ids: home.id)
    expect(bargain.save).to be false
  end

  it 'should not create bargain - no description' do
    bargain = build(:bargain, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                  category_ids: home.id)
    expect(bargain.save).to be false
  end

  it 'should not create bargain - no ends_at date' do
    bargain = build(:bargain, :short_description, :valid_link, :title, user_id: test_user.id,
                                                                       category_ids: home.id)
    expect(bargain.save).to be false
  end

  it 'should not create bargain - obsolete ends_at' do
    expect do
      create(:bargain, :short_description, :obsolete, :valid_link, :title, user_id: test_user.id,
                                                                           category_ids: home.id)
    end.to raise_error ActiveRecord::RecordNotSaved
  end

  it 'should deactivate bargain on save - obsolete ends_at date' do
    bargain = build(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                      category_ids: home.id)
    expect(bargain.save).to be true
    bargain = bargain.reload
    bargain.ends_at = DateTime.now - 10.days
    bargain.save
    expect(bargain.reload.active).to be false
  end
end
