FactoryBot.define do
  factory :topic do
    title { "Test topic" }
    is_public { false }
    user {}
  end
end
