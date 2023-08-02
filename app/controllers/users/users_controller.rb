module Users
  class UsersController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
    respond_to :json

    def update_password
      if current_user.update(password: params[:password])
        render json: {
          status: { code: 200, message: 'Password has been changed!.' }
        }, status: :ok
      else
        render json: {
          status: { code: 400, message: 'Could not change password!.' }
        }, status: :bad_request
      end
    end

    def update_email
      if current_user.update(email: params[:email])
        render json: {
          status: { code: 200, message: 'Email has been changed!.' }
        }, status: :ok
      else
        render json: {
          status: { code: 400, message: 'Could not change email!.' }
        }, status: :bad_request
      end
    end

    def check_password
      if current_user.valid_password?(params[:password])
        render json: {
          status: { code: 200, message: 'Password is correct!.' }
        }, status: :ok
      else
        render json: {
          status: { code: 400, message: 'Password incorrect!.' }
        }, status: :bad_request
      end
    end
  end
end
