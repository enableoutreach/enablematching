class Device < ApplicationRecord
  has_many :requests, dependent: :nullify
end
