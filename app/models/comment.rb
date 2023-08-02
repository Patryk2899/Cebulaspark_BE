class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :bargain

  validates_presence_of :body, :user_id, :bargain_id

  scope :by_id, ->(id) { where(id:) }
  scope :active, -> { where(deleted: false) }
  scope :by_bargain, ->(id) { where(bargain_id: id) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[bargain_id body created_at deleted id updated_at user_id]
  end

  def destroy
    update_attribute(:deleted, true)
  end
end
