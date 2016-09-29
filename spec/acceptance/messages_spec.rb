require 'acceptance_helper'

resource "Messages", acceptance: true do
  let(:user) { FactoryGirl.create(:user_with_session) }
  let(:room) { FactoryGirl.create(:room_with_messages) }

  before do
    header 'access_token', user.sessions.last.access_token
    header 'Content-Type', 'application/json'
  end

  post "/api/v1/rooms/:id/messages" do
    let(:id) { room.id }

    parameter :content, "Message content", required: true, scope: :message

    let(:message_content) { Faker::Lorem.sentence(3) }
    let(:raw_post) { params.to_json }

    example_request "Create a message" do
      expect(status).to eq 201
    end
  end

  delete "/api/v1/rooms/:room_id/messages/:id" do
    let(:room_id) { room.id }
    let(:id) { room.messages.last.id }
    example_request "Deleting a specific message" do
      expect(status).to eq 200
    end
  end

end