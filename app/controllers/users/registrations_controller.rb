# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    include RackSessionFix
    respond_to :json
    protect_from_forgery except: :create

    def create
      super
    end

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        render json: {
          status: { code: 200, message: 'Signed up sucessfully.' },
          data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }
      else
        render json: {
          status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    end
  end
end
