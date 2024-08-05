require 'rails_helper'

RSpec.describe "Api::V1::Modes" do
  describe "GET /api/v1/modes" do
    before do
      create_list(:mode, 3)
    end

    it "returns success status" do
      get '/api/v1/modes'
      expect(response).to have_http_status(:success)
    end

    it "returns correct number of modes" do
      get '/api/v1/modes'
      expect(response.parsed_body.size).to eq(3)
    end
  end
end
