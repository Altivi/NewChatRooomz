FactoryGirl.define do
  factory :room do
    creator
    title { Faker::Number.number(15).to_s }
  	
  	factory :room_with_messages do
      after(:create) do |instance|
        instance.messages.create(content: Faker::Lorem.sentence, author: instance.creator)
      end
    end
  end
end