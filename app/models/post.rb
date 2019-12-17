class Post < ApplicationRecord
  belongs_to :topic
  before_save :set_uuid
  validates :uuid, uniqueness: true

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
