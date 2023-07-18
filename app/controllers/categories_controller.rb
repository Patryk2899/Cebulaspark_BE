class CategoriesController < ApplicationController
  def fetch
    categories = Category.active.to_a
    render json: categories, status: :ok
  end
end
