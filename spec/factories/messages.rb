FactoryGirl.define do
  factory :message do
    author
    association :room, factory: :room
    content { Faker::Lorem.sentence }
  end
end