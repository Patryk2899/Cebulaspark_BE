class Category < ApplicationRecord
  has_and_belongs_to_many :bargains

  validates :name, presence: true, uniqueness: true

  before_save :set_as_active

  scope :active, -> { where(active: true) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[active created_at id name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['bargains']
  end

  private

  def set_as_active
    self.active = true
  end
end
