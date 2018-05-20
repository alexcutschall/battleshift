require 'rails_helper'

describe 'as player 1' do
  context 'send a request to player 2' do
    it 'creates a game' do
      user, user2 = create_list(:activated_user, 2)

      conn = Faraday.new(:url => 'http://localhost:3000')

      response = conn.post do |req|
        req.url '/api/v1/games'
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-API-Key'] = user.api_key
        req.body = { 'opponent_email': ENV['BATTLESHIFT_OPPONENT_EMAIL'] }.to_json
      end

      expect(response).to be_success
    end
    it 'refuses to create if user isnt in system' do
      user = create(:activated_user)

      conn = Faraday.new(:url => 'http://localhost:3000')

      response = conn.post do |req|
        req.url '/api/v1/games'
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-API-Key'] = user.api_key
        req.body = { 'opponent_email': user.email }.to_json
      end

      expect(response.status).to eq(400)
    end
    it 'refuses if it is sent an invalid API Key' do
      user = create(:activated_user)

      conn = Faraday.new(:url => 'http://localhost:3000')

      response = conn.post do |req|
        req.url '/api/v1/games'
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-API-Key'] = "1"
        req.body = { 'opponent_email': ENV['BATTLESHIT_OPPONENT_EMAIL'] }.to_json
      end

      expect(response.status).to eq(400)
    end
  end
end
