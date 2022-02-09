class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :unit_price, numericality: true
end
