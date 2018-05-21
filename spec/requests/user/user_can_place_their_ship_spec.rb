require 'rails_helper'

describe 'as a user' do
  context 'they place a ship' do
    it 'is correctly placed' do
      user, user_2 = create_list(:activated_user, 2)
      player_1_board = Board.new(4)
      player_2_board = Board.new(4)
      game = Game.create(id: 64, player_1_id: user.id,
        player_2_id: user_2.id, player_1_board: player_1_board, player_2_board: player_2_board)

      conn = Faraday.new(:url => 'http://localhost:3000')

      response = conn.post do |req|
        req.url "/api/v1/games"
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-API-Key'] = ENV['BATTLESHIFT_API_KEY']
        req.body = { 'opponent_email': ENV['BATTLESHIFT_EMAIL'] }.to_json 
      end

      expect(response).to be_success
      game_json = JSON.parse(response.body, symbolize_names: true)

      response = conn.post do |req|
        req.url "/api/v1/games/#{game_json[:id]}/ships"
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-API-Key'] = ENV['BATTLESHIFT_API_KEY']
        req.body = {
          'email': ENV['BATTLESHIFT_OPPONENT_EMAIL'],
          'ship_size': 2,
          'start_space': "A1",
          'end_space': "A2"
        }.to_json
      end

      expect(response).to be_success
    end
  end
end
