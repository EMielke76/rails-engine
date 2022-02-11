class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.search(params)
    where("name ILIKE ?", "%#{params}%").order(:name)
  end
end
