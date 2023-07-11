require 'rails_helper'

RSpec.describe Category, type: :model do
  let!(:electronic) { create :category, :electronics }
  let!(:home) { create :category, :home }
  let!(:health) { create :category, :health }

  it 'should succesfully save category' do
    category = Category.new({ name: 'food' })
    expect(category.save).to be true
    expect(category.reload.active).to be true
  end

  it 'should not create category - lack of name' do
    category = Category.new({})
    expect(category.save).to be false
  end

  it 'should not create category - name not uniq' do
    home
    category = Category.new({ name: 'home' })
    expect(category.save).to be false
  end
end
