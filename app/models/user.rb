class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :bargains

  validates_uniqueness_of :email

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum user_role: %i[user admin]
  after_initialize :set_default_role, if: :new_record?

  def self.reset_password_by_token(attributes = {})
    super
  end

  private

  def set_default_role
    self.user_role ||= :user
  end
end
