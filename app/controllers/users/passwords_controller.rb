module Users
  class PasswordsController < ApplicationController
    respond_to :json
    protect_from_forgery except: %i[create update]
    def create
      PasswordService.new.send_password_change_request(params[:email])
      respond_on_change_request
    end

    def update
      status = PasswordService.new.update_password(params[:reset_password_token], params[:password],
                                                   params[:password_confirmation])
      respond_on_update(status)
    end

    private

    def respond_on_change_request
      render json: {
        status: { code: 200, message: 'Email has been sent!.' }
      }, status: :ok
    end

    def respond_on_update(status)
      if status == 401
        render json: {
          status: { code: 401, message: 'Unauthorized' }
        }, status: :unauthorized
      else
        render json: {
          status: { code: 200, message: 'Password has been changed' }
        }, status: :ok
      end
    end
  end
end
