class Category < ApplicationRecord
  has_and_belongs_to_many :bargains

  validates :name, presence: true, uniqueness: true

  before_save :set_as_active

  scope :active, -> { where(active: true) }

  private

  def set_as_active
    self.active = true
  end
end
