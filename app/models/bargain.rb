class Bargain < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_bargain,
                  against: %i[title description], associated_against: { categories: [:name] }, using: {
                    tsearch: { prefix: true }
                  }
  has_and_belongs_to_many :categories
  has_many :bargain_categories
  accepts_nested_attributes_for :categories, allow_destroy: true

  has_many :comments
  belongs_to :user
  has_one_attached :main_image
  validate :has_category
  validates :title, length: { in: 4..70 }
  validates_presence_of :description, :title, :ends_at
  before_save :validate_link
  before_create :validate_ends_at
  before_create :set_as_active

  before_update :deactivate_if_obsolete

  attr_accessor :bargains_categories

  scope :by_id, ->(id) { where(id:) }

  scope :by_category_id, ->(category_id) { joins(:categories).where(categories: { id: category_id }) }
  scope :active, -> { where(active: true) }
  pg_search_scope :search_title, against: :title

  def destroy
    update_attribute(:active, false)
  end

  def main_image_url
    return Rails.application.routes.url_helpers.url_for(main_image) if main_image.attached?

    nil
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[active created_at description ends_at id link title updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[categories comments main_image_attachment main_image_blob user]
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
    return unless ends_at <= Date.today

    errors.add(:ends_at, 'Ending date is in the past')
    throw :abort
  end

  def set_as_active
    self.active = true
  end

  def deactivate_if_obsolete
    self.active = (!(ends_at < DateTime.now))
  end
end
