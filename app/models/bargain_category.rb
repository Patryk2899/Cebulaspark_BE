class BargainCategory < ApplicationRecord
  belongs_to :category
  belongs_to :bargain
end
