FactoryBot.define do
  factory :post do
    title { "test post always" }
    content { "test content.. duh!" }
    is_public { false }
    topic {}
  end
end
