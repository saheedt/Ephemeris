class Post < ApplicationRecord
  belongs_to :topic
  before_save :set_uuid
  validates :uuid, uniqueness: true
end
