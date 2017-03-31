class Chapter < ApplicationRecord
  
  has_one :member #lead

  geocoded_by :map_location   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
  validates :name, :email, :location, :evidence, presence: true

  def map_location    
    return self.location
  end

end
