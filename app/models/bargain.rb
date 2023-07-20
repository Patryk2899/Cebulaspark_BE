class Bargain < ApplicationRecord
  include PgSearch::Model
  has_and_belongs_to_many :categories, through: :bargains_categories

  has_many :comments
  belongs_to :user
  has_one_attached :main_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [250, 250]
  end

  validate :has_category
  validates :title, length: { in: 4..70 }
  validates_presence_of :description, :title, :ends_at
  before_save :validate_link
  before_create :validate_ends_at
  before_create :set_as_active

  before_save :deactivate_if_obsolete

  scope :by_id, ->(id) { where(id:) }

  scope :by_category_id, ->(category_id) { joins(:categories).where(categories: { id: category_id }) }
  scope :active, -> { where(active: true) }
  pg_search_scope :search_title, against: :title

  def destroy
    update_attribute(:active, false)
  end

  def main_image_url
    return Rails.application.routes.url_helpers.url_for(self.main_image) if self.main_image.attached?
    nil
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
