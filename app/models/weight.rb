class Weight < ApplicationRecord
  belongs_to :user
  
  validates :weight, presence: true, numericality: 0
end
