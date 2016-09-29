FactoryGirl.define do
  factory :session do
    user
    device_token "123qwe456rty"
    device_type "ios"
  end
end