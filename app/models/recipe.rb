class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category
  
  validates :name, presence: true
  validates :ingredients, presence: true
  validates :category, presence: true
  validates :journey, presence: true
end
