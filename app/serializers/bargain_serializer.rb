class BargainSerializer < ActiveModel::Serializer
  attributes :id, :ends_at, :title, :description, :link, :main_image_url
end
