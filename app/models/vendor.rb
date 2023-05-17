class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors
  validates_presence_of :name, :description, :contact_name, :contact_phone
  validates_inclusion_of :credit_accepted, in: [true, false]
  # validates :credit_accepted_presence

  # def credit_accepted_presence
  #   return if credit_accepted == true || credit_accepted == false
    
  #   errors.add(:credit_accepted, "must be true or false")
  # end
end