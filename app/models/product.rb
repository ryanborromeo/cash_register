class Product < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  scope :by_code, -> { order(:code) }
  scope :active, -> { where(active: true) }

  def self.find_by_code(code)
    find_by(code: code)
  end
end
