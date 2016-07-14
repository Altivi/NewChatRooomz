require 'acceptance_helper'

resource "Sessions", acceptance: true do
  let(:user) { FactoryGirl.create(:user_with_session) }
  # let(:user) { FactoryGirl.create(:user_with_room_and_session) }
  # let(:room) { FactoryGirl.create(:room) }

  before do
    header 'Content-Type', 'application/json'
  end

  post "/api/v1/login" do

    with_options scope: :user do 
      parameter :email, "User email", required: true
      parameter :password, "User password", required: true
      parameter :session, "User session", required: true
    end

    with_options scope: :session do
      parameter :device_type, "Device type", required: true
      parameter :device_token, "Device token", required: true
      parameter :push_token, "Push type", required: true
    end

    let(:user_email) { user.email }
    let(:user_password) { "123123" }

    let(:session_device_type) { user.sessions.last.device_type }
    let(:session_device_token) { user.sessions.last.device_token }
    let(:session_push_token) { user.sessions.last.push_token }
    let(:raw_post) { params.to_json }

    example_request "Log in" do
      expect(status).to eq 201
      expect(response_headers["access_token"]).to_not be_nil
    end
  end

  delete "/api/v1/logout" do
    before do
      header 'access_token', user.sessions.last.access_token
    end
    let(:id) { user.rooms.last.id }
    example_request "Log out" do
      expect(status).to eq 200
    end
  end

end