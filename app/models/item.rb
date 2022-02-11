class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true, format: {with: /[a-zA-Z]/}
  validates :unit_price, numericality: true

  def self.search(params)
    where("name ILIKE ?", "%#{params}%").order(:name)
  end

  def self.min_price_search(price)
    where("unit_price >= ?", "#{price}")
  end

  def self.max_price_search(price)
    where("unit_price <= ?", "#{price}")
  end

  def self.min_max_price_search(low, high)
    where("unit_price >= #{low} AND unit_price <= #{high}")
  end
end
