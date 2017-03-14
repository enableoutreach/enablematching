class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    has_many :requests, dependent: :destroy #destroy all requests associated with this member
    has_many :offers, dependent: :restrict_with_exception #don't allow member to be deleted if they have matches  

  geocoded_by :map_address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
  
  def map_address
    return self.city+", "+self.country
  end
end
