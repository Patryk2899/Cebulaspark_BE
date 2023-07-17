class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :bargain

  validates_presence_of :body, :user_id, :bargain_id

  scope :by_id, ->(id) { where(id:) }
  scope :active, -> { where(deleted: false) }
  scope :by_bargain, ->(id) { where(bargain_id: id) }

  def destroy
    update_attribute(:deleted, true)
  end
end
