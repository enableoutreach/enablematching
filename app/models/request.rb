class Request < ApplicationRecord
  belongs_to :member # id of recipient
  has_one :device #device they requested

  geocoded_by :map_address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  def self.open_offer(mem, req)
    return !Offer.where(member_id: mem.id, request_id: req.id).empty?
  end
  
  def self.accepted_offer(mem, req)
    return !Offer.where(member_id: mem.id, request_id: req.id, stage: 'Accepted').empty?
  end

  def map_address
    #might be better to find city, country from shipping address so geocode is not on someone's house.  For now, will restrict zoom level of map, but may be able to get geocode from script.
    return self.shipping_address
  end
end