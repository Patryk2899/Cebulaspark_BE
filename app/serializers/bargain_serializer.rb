class BargainSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :title, :description, :link, :main_image_url
end
