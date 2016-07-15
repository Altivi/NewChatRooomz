require 'acceptance_helper'

resource "Rooms", acceptance: true do
  # let(:user) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create(:user_with_room_and_session) }
  let(:room) { FactoryGirl.create(:room) }

  before do
    header 'access_token', user.sessions.last.access_token
    header 'Content-Type', 'application/json'
  end

  get "/api/v1/rooms" do
    example_request "Listing rooms" do
      expect(status).to eq 200
    end
  end

  get "/api/v1/rooms/:id" do
    let(:id) { room.id }
    example_request "Getting a specific room" do
      expect(status).to eq 200
    end
  end

  post "/api/v1/rooms" do
    parameter :title, "Room title", required: true, scope: :room

    let(:room_title) { Faker::Code.imei }
    let(:raw_post) { params.to_json }

    example_request "Create a specific room" do
      expect(status).to eq 201
    end
  end

  delete "/api/v1/rooms/:id" do
    let(:id) { user.rooms.last.id }
    example_request "Deleting a specific room" do
      expect(status).to eq 200
    end
  end

end