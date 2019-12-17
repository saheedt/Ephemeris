class Topic < ApplicationRecord
  belongs_to :user
  has_many :posts
  validates :uuid, uniqueness: true
  before_save :set_uuid

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
