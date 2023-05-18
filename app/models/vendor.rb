class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  validates :name, presence: true
  validates :description, presence: true
  validates :contact_name, presence: true
  validates :contact_phone, presence: true
  validates :credit_accepted, exclusion: { :in => [nil], :message => "can't be blank" }

  def market_vendor_delete
    market_vendors.each do |m_v|
      m_v.delete
    end
  end
end