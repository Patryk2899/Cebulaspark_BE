class Category < ApplicationRecord
  has_many :bargain_categories
  has_many :bargains, through: :bargain_categories

  validates :name, presence: true, uniqueness: true

  before_save :set_as_active

  private

  def set_as_active
    self.active = true
  end
end
