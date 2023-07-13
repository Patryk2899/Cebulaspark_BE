class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :bargain

  validates_presence_of :body, :user_id, :bargain_id

  def destroy
    update_attribute(:status, 0)
  end
end
