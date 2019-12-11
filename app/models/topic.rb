class Topic < ApplicationRecord
  belongs_to :user

  validates :uuid, uniqueness: true

  before_save :set_uuid

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
