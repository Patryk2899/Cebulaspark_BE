class CurrentUserController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  respond_to :json

  def index
    render json: current_user, status: :ok
  end
end
