class Micropost < ApplicationRecord
    belongs_to :user
    has_one_attached :image
    validates :content, length: { maximum: 140 }, presence: true
    validates :user_id, presence: true
   
  
  # Returns a resized image for display.
    def display_image
         image.variant(resize_to_limit: [500, 500])
    end
end
