class Topic < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  validates :uuid, uniqueness: true
  before_save :set_uuid
end
