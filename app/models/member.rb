class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    has_many :requests, dependent: :destroy #destroy all requests associated with this member
    has_many :offers, dependent: :restrict_with_exception #don't allow member to be deleted if they have matches  

  geocoded_by :map_address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
  validates :first_name, presence: true  
  
  def map_address
    return self.city+", "+self.country
  end
  
  def load_badges
    require 'httparty'
    url = 'https://api.credly.com/v1.1/members?email=' << CGI.escape(self.email)
    
    temp2 = HTTParty.get(url, :verify => false, :headers => {"X-Api-Key" => ENV['CRED_KEY'], "X-Api-Secret" => ENV['CRED_SECRET']})['data']
    if !temp2.nil? 
      credid = temp2[0]['id']
      
      url = 'https://api.credly.com/v1.1/members/' << credid.to_s << '/badges?query=e-nable'
      return HTTParty.get(url, :verify => false, :headers => {"X-Api-Key" => ENV['CRED_KEY'], "X-Api-Secret" => ENV['CRED_SECRET']}).parsed_response['data']
    end
  end
  
end
