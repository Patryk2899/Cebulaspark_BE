require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:test_user) { create :user, :basic_email, :default_role, :random_password }
  let!(:home) { create :category, :home }

  it 'should create comment - valid entry' do
    bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                       category_ids: home.id)
    comment = build(:comment, :simple_body, user_id: test_user.id, bargain_id: bargain.id)
    expect(comment.save).to be true
  end

  it 'should not create comment - lack of bargain_id' do
    comment = build(:comment, :simple_body, user_id: test_user.id, bargain_id: nil)
    expect(comment.save).to be false
  end

  it 'should not create comment - lack of user_id' do
    bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                       category_ids: home.id)
    comment = build(:comment, :simple_body, bargain_id: bargain.id)
    expect(comment.save).to be false
  end

  it 'should not create comment - lack of body' do
    bargain = create(:bargain, :short_description, :not_obsolete, :valid_link, :title, user_id: test_user.id,
                                                                                       category_ids: home.id)
    comment = build(:comment, user_id: test_user.id, bargain_id: bargain.id)
    expect(comment.save).to be false
  end
end
