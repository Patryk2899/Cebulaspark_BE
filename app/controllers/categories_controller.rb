class CategoriesController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json
  def fetch
    categories = Category.active.to_a
    render json: categories, status: :ok
  end
end
