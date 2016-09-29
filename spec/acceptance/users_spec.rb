require 'acceptance_helper'

resource "Users", acceptance: true do

  before do
    header 'Content-Type', 'application/json'
  end

  post "/api/v1/signup" do
    parameter :email, "Email", required: true, scope: :user
    parameter :password, "Password", required: true, scope: :user
    parameter :avatar, "Avatar", scope: :user
    parameter :nickname, "Nickname", required: true, scope: :user

    let(:user_email) { Faker::Internet.email }
    let(:user_password) { "123123" }
    let(:user_nickname) { Faker::Name.name }
    let(:user_avatar) { Faker::Avatar.image("my-own-slug", "100x100") }
    let(:raw_post) { params.to_json }

    example_request "Sign up" do
      expect(status).to eq 200
    end
  end

end