class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :content, presence: true, length: { minimum: 1, maximum: 500 }
  validates :user_id, presence: true
  validates :post_id, presence: true
# app/models/comment.rb
scope :ordered, -> { order(:created_at) }
end
