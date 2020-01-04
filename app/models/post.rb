class Post < ApplicationRecord
  belongs_to :topic
  before_save :set_uuid
  validates_presence_of :title
  validates :content, exclusion: { in: [nil], message: "cannot be null" }
  validates :uuid, uniqueness: true
end
