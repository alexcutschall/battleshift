require 'rails_helper'

describe 'as player 1' do
  context 'send a request to player 2' do
    let(:user) { create(:activated_user) }
    let(:user2) { create(:activated_user) }
    let(:opponent) {
      { 'opponent_email': user2.email }.to_json
    }
    it 'creates a game' do
      headers = {
        'Content-Type' => 'application/json',
        'X-API-Key' => user.api_key
      }

      post '/api/v1/games', headers: headers, params: opponent

      expect(response).to be_successful
    end
    it 'refuses to create if user isnt in system' do
      headers = {
        'Content-Type' => 'application/json',
        'X-API-Key' => user.api_key
      }

      post '/api/v1/games', headers: headers, params: { 'opponent_email': 'invalid' }.to_json

      expect(response.status).to eq(400)
    end
    it 'refuses if it is sent an invalid API Key' do
      headers = {
        'Content-Type' => 'application/json',
        'X-API-Key' => '1'
      }
      post '/api/v1/games', headers: headers, params: opponent

      expect(response.status).to eq(400)
    end
  end
end
