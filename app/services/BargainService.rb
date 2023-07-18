# frozen_string_literal: true

class BargainService
  def initialize(params, current_user)
    @bargain_params = params[:bargain]
    @categories = params[:category]
    @image = params[:image]
    @current_user = current_user
    @current_ability = Ability.new(@current_user)
  end

  def create
    bargain = Bargain.new(@bargain_params&.compact)
    bargain.user = @current_user

    bargain.main_image.attach(@image) if @image

    bargain.categories << Category.find(@categories.to_hash.map { |_key, value| value['id'].to_i }) if @categories

    return :ok if bargain.save

    :bad_request
  end

  def update
    bargain = Bargain.accessible_by(@current_ability).by_id(@bargain_params['id']).to_a.first

    return :bad_request if bargain.nil?
    return :bad_request if bargain.user != @current_user

    bargain.main_image.attach(@image) if @image
    bargain.categories = Category.find(@categories.map { |category| category['id'] }) if @categories
    @bargain_params.delete(:id)
    return :bad_request unless Bargain.update(bargain.id, @bargain_params).errors.empty?

    :ok
  end

  def destroy
    bargain = Bargain.accessible_by(@current_ability).by_id(@bargain_params['id']).to_a.first
    return :bad_request unless bargain

    bargain.destroy
    :ok
  end
end
