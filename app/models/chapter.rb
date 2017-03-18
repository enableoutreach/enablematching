class Chapter < ApplicationRecord
  
  has_one :member #lead

  geocoded_by :map_location   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  def map_location    
    return self.location
  end

end
