class Request < ApplicationRecord
  belongs_to :member # id of recipient
  has_one :device #device they requested

  geocoded_by :map_address   # can also be an IP address
  after_validation :geocode, if: ->(obj){ obj.shipping_address.present? and obj.shipping_address_changed? }          # auto-fetch coordinates
  validates :side, :shipping_address, presence: true

  def open_offer(mem)
    return !Offer.where(member_id: mem.id, request_id: self.id).empty?
  end
  
  def accepted_offer(mem)
    return !Offer.where(member_id: mem.id, request_id: self.id, stage: 'Accepted').empty?
  end

  def map_address
    #might be better to find city, country from shipping address so geocode is not on someone's house.  For now, will restrict zoom level of map, but may be able to get geocode from script.
    return self.shipping_address
  end
end