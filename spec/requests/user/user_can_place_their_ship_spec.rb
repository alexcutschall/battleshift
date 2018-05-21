require 'rails_helper'

describe 'as a user' do
  let(:user) { create(:activated_user) }
  let(:user2) { create(:activated_user) }
  let(:game) { create(:game, player_1: user, player_2: user2, player_1_board: Board.new(4), player_2_board: Board.new(4)) }

  context 'they place a ship' do
    it 'is correctly placed' do

      headers = {
        'Content-Type' => 'application/json',
        'X-API-Key' => user.api_key
      }
      body = {
        'ship_size' => 2,
        'start_space' => 'A1',
        'end_space' => 'A2'
      }.to_json

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: body

      expect(response).to be_successful
      game.reload
      expect(game.player_1_board.board.flatten.first["A1"].contents).to be_a Ship
    end

    it 'and their opponent can too' do
      headers = {
        'Content-Type' => 'application/json',
        'X-API-Key' => user2.api_key
      }
      body = {
        'ship_size' => 2,
        'start_space' => 'A1',
        'end_space' => 'A2'
      }.to_json

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: body

      expect(response).to be_successful
      game.reload
      expect(game.player_2_board.board.flatten.first["A1"].contents).to be_a Ship
    end
  end
end
