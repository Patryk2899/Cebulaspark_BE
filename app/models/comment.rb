class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :bargain

  validates_presence_of :body, :user_id, :bargain_id
end
