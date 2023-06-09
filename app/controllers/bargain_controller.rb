class BargainController < ApplicationController
  before_action :authenticate_user!

  def create
    status = BargainService.new(bargain_params, current_user).create
    respond_on_create(status)
  end

  def update
    status = BargainService.new(bargain_params, current_user).update
    respond_on_update(status)
  end

  def destroy
    status = BargainService.new(params, current_user).destroy
    respond_on_destroy(status)
  end

  private

  def bargain_params
    params.permit!
    params
  end

  def respond_on_create(status)
    if status == :bad_request
      render json: {
        status: { code: 400, message: 'Could not create bargain, validation failed' }
      }, status: :bad_request
    else
      render json: {
        status: { code: 200, message: 'Bargain has been created' }
      }, status: :ok
    end
  end

  def respond_on_update(status)
    if status == :unauthorized
      render json: {
        status: { code: 401, message: 'Unauthorized' }
      }, status: :unauthorized
    elsif status == :bad_request
      render json: {
        status: { code: 400, message: 'Could not update bargain, validation failed' }
      }, status: :bad_request
    else
      render json: {
        status: { code: 200, message: 'Bargain has been updated' }
      }, status: :ok
    end
  end

  def respond_on_destroy(status)
    if status == :unauthorized
      render json: {
        status: { code: 401, message: 'Unauthorized' }
      }, status: :unauthorized
    elsif status == :bad_request
      render json: {
        status: { code: 400, message: 'Could not find such a bargain' }
      }, status: :ok
    else
      render json: {
        status: { code: 200, message: 'Bargain has been deleted' }
      }, status: :ok
    end
  end
end
