require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'GET /index' do
    it 'should fetch categories' do
      get :fetch
      expect(response.body.size).equal?(Category.active.size)
      expect(response).to have_http_status(:success)
    end
  end
end
