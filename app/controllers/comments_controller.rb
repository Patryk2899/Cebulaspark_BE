class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]
  skip_before_action :verify_authenticity_token
  respond_to :json

  def show
    comments = Comment.by_bargain(show_params[:bargain_id]).active.to_a

    render status: :ok, json: comments, each_serializer: CommentsSerializer
  end

  def create
    comment = Comment.new({ body: params[:body], bargain_id: params[:bargain_id], user_id: current_user.id })

    if comment.save
      render json: {
        status: { code: 200, message: 'Comment created' }
      }, status: :ok
    else
      render json: {
        status: { code: 400, message: 'Could not create comment, validation failed' }
      }, status: :bad_request
    end
  end

  def update
    comment = Comment.accessible_by(current_ability).by_id(update_params[:id])&.to_a&.first

    if comment.present?
      comment.body = update_params[:body]
      comment.save ? success_on_update : bad_request_on_update
    else
      render json: {
        status: { code: 400, message: 'Could not update comment, validation failed' }
      }, status: :bad_request
    end
  end

  def destroy
    comment = Comment.accessible_by(current_ability).by_id(update_params[:id])&.to_a&.first

    if comment.present?
      comment.destroy

      render json: {
        status: { code: 200, message: 'Comment deleted' }
      }, status: :ok
    else
      render json: {
        status: { code: 400, message: 'Could not destroy comment, validation failed' }
      }, status: :bad_request
    end
  end

  private

  def update_params
    params.permit(:id, :body)
  end

  def destroy_params
    params.permit(:id)
  end

  def show_params
    params.permit(:bargain_id)
  end

  def bad_request_on_update
    render json: {
      status: { code: 400, message: 'Could not update comment, validation failed' }
    }, status: :bad_request
  end

  def success_on_update
    render json: {
      status: { code: 200, message: 'Could not update comment, validation failed' }
    }, status: :ok
  end
end
