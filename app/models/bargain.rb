class Bargain < ApplicationRecord
  has_many :bargain_categories
  has_many :categories, through: :bargain_categories
  belongs_to :user

  validates :categories, length: { minimum: 1 }
  validates_presence_of :description, :title, :ends_at
  before_save :validate_link
  before_create :validate_ends_at
  before_create :set_as_active

  before_save :deactivate_if_obsolete

  private

  def validate_link
    return if LinkValidationService.new(link).valid?

    errors.add(:link, 'Link validation failed')
    throw :abort
  end

  def validate_ends_at
    return unless ends_at.< DateTime.now

    errors.add(:ends_at, 'Ending date is in the past')
    throw :abort
  end

  def set_as_active
    self.active = true
  end

  def deactivate_if_obsolete
    self.active = false if ends_at < DateTime.now
  end
end
