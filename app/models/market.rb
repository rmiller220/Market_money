class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors
  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :county, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :lat, presence: true
  validates :lon, presence: true

  def vendor_count
    self.vendors.count
  end

  def self.search_markets(state, name, city)
    where("state ILIKE? and name ILIKE ? and city ILIKE ? ", "%#{state}%", "%#{name}%", "%#{city}%")
  end
end