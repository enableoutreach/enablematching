class Offer < ApplicationRecord
  belongs_to :request #id of request from recipient
  has_one :member #id of maker offering to help
  
  NEW_OFFER_CONTENT = "An offer has been made"
end
