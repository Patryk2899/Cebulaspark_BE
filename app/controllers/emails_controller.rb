class EmailsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  respond_to :json
  def update
    if current_user.valid_password?(params[:password])
      current_user.email = params[:email]
      if current_user.save
        render status: :ok
      else
        render status: :bad_request, json: { message: 'Email has been taken' }
      end
    else
      render status: :unauthorized
    end
  end
end
