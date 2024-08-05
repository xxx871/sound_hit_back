require 'rails_helper'

RSpec.describe "Api::V1::Auth::Registrations" do
  describe "POST /api/v1/auth" do
    subject(:register_user) { post '/api/v1/auth', params: attributes }

    context "with valid attributes" do
      let(:attributes) { attributes_for(:user) }

      it "creates a new user" do
        expect { register_user }.to change(User, :count).by(1)
      end

      it "returns a success status" do
        register_user
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid attributes" do
      let(:attributes) { attributes_for(:user, email: 'invalid', password: 'short', name: '') }

      it "does not create a new user" do
        expect { register_user }.not_to change(User, :count)
      end

      it "returns unprocessable entity status" do
        register_user
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
