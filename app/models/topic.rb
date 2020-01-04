class Topic < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  validates :title, presence: true
  validates :is_public, inclusion: { in: [true, false],  message: "can only be boolean" }
  validates :uuid, uniqueness: true
  before_save :set_uuid
end
