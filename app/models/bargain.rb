class Bargain < ApplicationRecord
  has_and_belongs_to_many :categories

  has_many :comments
  belongs_to :user

  validate :has_category
  validates :title, length: { in: 4..70 }
  validates_presence_of :description, :title, :ends_at
  before_save :validate_link
  before_create :validate_ends_at
  before_create :set_as_active

  before_save :deactivate_if_obsolete

  scope :by_id, ->(id) { where(id:) }

  def destroy
    update_attribute(:active, false)
  end

  private

  def has_category
    return unless categories.empty?

    errors.add(:categories, 'need at least category')
  end

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
