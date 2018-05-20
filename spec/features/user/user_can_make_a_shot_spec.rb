require 'rails_helper'

context 'A user posting to /api/v1/games/:id/shots' do
  describe 'can place a shot' do
    before(:all) do
      @conn = Faraday.new(url: 'http://localhost:3000')

      response = @conn.post do |req|
        req.url "/api/v1/games"
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-API-Key'] = ENV['BATTLESHIFT_API_KEY']
        req.body = { 'opponent_email': ENV['BATTLESHIFT_OPPONENT_EMAIL'] }.to_json
      end

      @game_json = JSON.parse(response.body, symbolize_names: true)

      @conn.post do |req|
        req.url "/api/v1/games/#{@game_json[:id]}/ships"
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-API-Key'] = ENV['BATTLESHIFT_OPPONENT_API_KEY']
        req.body = {
          'ship_size': 2,
          'start_space': "A1",
          'end_space': "A2"
        }.to_json
      end
    end

    scenario 'that hits' do
      response = @conn.post do |req|
        req.url "/api/v1/games/#{@game_json[:id]}/shots"
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-API-Key'] = ENV['BATTLESHIFT_API_KEY']
        req.body = { target: "A1" }.to_json
      end

      expect(response).to be_success
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to include("Your shot resulted in a Hit")
      expect(data[:player_2_board][:rows].first[:data].first[:status]).to eq("Hit")

    end

    scenario 'that misses' do
      response = @conn.post do |req|
        req.url "/api/v1/games/#{@game_json[:id]}/shots"
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-API-Key'] = ENV['BATTLESHIFT_API_KEY']
        req.body = { target: "D1" }.to_json
      end

      expect(response).to be_success
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to include("Your shot resulted in a Miss")
      expect(data[:player_2_board][:rows][3][:data].first[:status]).to eq("Miss")
    end

    scenario 'wrong coordinate' do
      response = @conn.post do |req|
        req.url "/api/v1/games/#{@game_json[:id]}/shots"
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-API-Key'] = ENV['BATTLESHIFT_API_KEY']
        req.body = { target: "D5" }.to_json
      end

      expect(response).to be_success
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to include("Invalid coordinates")
      expect(data[:player_2_board][:rows][3][:data].first[:status]).to eq("Empty")
    end
  end
end
