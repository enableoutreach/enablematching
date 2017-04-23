class Review < ApplicationRecord
  validates :by, :for, :title, :content, :target_type, presence: true
end
