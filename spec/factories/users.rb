FactoryGirl.define do
  factory :user, aliases: [:author, :creator] do
    email { Faker::Internet.email }
    nickname { Faker::Company.profession }
    password "123123"
    password_confirmation "123123"
    after(:create) do |u|
	    u.confirm
	    u.save!
	  end

    factory :user_with_room_and_session do
      after(:create) do |instance|
        instance.rooms.create(title: Faker::Number.number(10).to_s, creator: instance)
        instance.sessions.create(device_token: Faker::Crypto.md5, push_token: Faker::Crypto.md5, device_type: "ios")
      end
    end

    factory :user_with_session do
      after(:create) do |instance|
        instance.sessions.create(device_token: Faker::Crypto.md5, push_token: Faker::Crypto.md5, device_type: "ios")
      end
    end

  end
end