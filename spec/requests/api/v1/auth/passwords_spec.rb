require 'rails_helper'

RSpec.describe 'Password Reset' do
  let(:user) { create(:user) }
  let(:password_reset_url) { '/api/v1/auth/password' }

  describe 'POST /api/v1/auth/password' do
    subject(:make_request) { post password_reset_url, params: { email: } }

    context 'when the email address is valid' do
      let(:email) { user.email }

      it 'returns a success status' do
        make_request
        expect(response).to have_http_status(:ok)
      end

      it 'returns a success message' do
        make_request
        expect(response.parsed_body['message']).to eq("'#{user.email}' にパスワードリセットの案内が送信されました。")
      end

      it 'sends an email' do
        expect { make_request }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'when the email address is invalid' do
      let(:email) { 'invalid@example.com' }

      before { make_request }

      it 'returns an error status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        expect(response.parsed_body['errors']).to include("メールアドレス 'invalid@example.com' のユーザーが見つかりません。")
      end
    end
  end
end
