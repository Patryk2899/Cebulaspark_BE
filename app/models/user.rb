class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  delegate :can?, :cannot?, to: :ability

  has_many :bargains
  has_many :comments
  validates_uniqueness_of :email

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum user_role: %i[user admin]
  after_initialize :set_default_role, if: :new_record?

  def self.reset_password_by_token(attributes = {})
    super
  end

  def admin?
    user_role == 'admin'
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[confirmation_sent_at confirmation_token confirmed_at created_at current_sign_in_at
       current_sign_in_ip email encrypted_password failed_attempts id jti last_sign_in_at last_sign_in_ip locked_at remember_created_at reset_password_sent_at reset_password_token sign_in_count unconfirmed_email unlock_token updated_at user_role]
  end

  private

  def set_default_role
    self.user_role ||= :user
  end
end
