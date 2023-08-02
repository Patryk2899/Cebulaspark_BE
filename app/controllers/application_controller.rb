class ApplicationController < ActionController::Base
  respond_to :html, :json
  include ActionController::MimeResponds
  include ActionView::Layouts
end
