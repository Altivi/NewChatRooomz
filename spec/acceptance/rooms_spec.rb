require 'acceptance_helper'

resource "Rooms" do
  get "/api/v1/rooms" do
    example "Listing rooms" do
      do_request

      expect(status).to be 200
    end
  end
end