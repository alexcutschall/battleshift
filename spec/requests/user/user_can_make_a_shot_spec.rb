require 'rails_helper'

context 'A user posting to /api/v1/games/:id/shots' do
  describe 'can place a shot' do
    let(:user) { create(:activated_user) }
    let(:user2) { create(:activated_user) }
    let(:game) { create(:game, player_1: user, player_2: user2, player_1_board: Board.new(4), player_2_board: Board.new(4))}

    let(:ship) { Ship.new(2) }
    let(:ship_placer) {
      ShipPlacer.new(
        board: game.player_2_board,
        ship: ship,
        start_space: "A1",
        end_space: "A2"
      )
    }

    before(:each) do
      ship_placer.run
      game.save!
    end

    scenario 'that hits' do
      headers = {
        'Content-Type' => 'application/json',
        'X-API-Key' => user.api_key
      }
      post "/api/v1/games/#{game.id}/shots", headers: headers, params: { target: 'A1' }.to_json

      expect(response).to be_successful
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:message]).to include("Your shot resulted in a Hit")
      expect(data[:player_2_board][:rows].first[:data].first[:status]).to eq("Hit")

    end

    scenario 'that misses' do
      headers = {
        'Content-Type' => 'application/json',
        'X-API-Key' => user.api_key
      }
      post "/api/v1/games/#{game.id}/shots", headers: headers, params: { target: 'D1' }.to_json

      expect(response).to be_success
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to include("Your shot resulted in a Miss")
      expect(data[:player_2_board][:rows][3][:data].first[:status]).to eq("Miss")
    end

    scenario 'and recieve an error for an invalid coordinate' do
      headers = {
        'Content-Type' => 'application/json',
        'X-API-Key' => user.api_key
      }
      post "/api/v1/games/#{game.id}/shots", headers: headers, params: { target: 'D10' }.to_json

      expect(response.status).to be(400)
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to include("Invalid coordinates")
      expect(data[:player_2_board][:rows][3][:data].first[:status]).to eq("Not Attacked")
    end
  end
end
