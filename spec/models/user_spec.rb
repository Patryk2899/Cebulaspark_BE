require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:basic_user) { create :user, :basic_email, :default_role, :random_password }
  let!(:user_wtih_same_email) { build :user, :basic_email, :random_password }
  let!(:user) { build :user, email: 'test@gmail.com', password: 'random_thing' }

  it 'should succesfully save user and add user role' do
    result = user.save
    expect(result).to be true
    user.reload.user_role.equal?(:user)
  end

  it 'should not create user when email is already taken' do
    result = user_wtih_same_email.save
    expect(result).to be false
  end
end
