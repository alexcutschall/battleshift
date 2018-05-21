require 'rails_helper'

context 'A user posting to /api/v1/games/:id/shots out of turn' do
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

  scenario 'is denied' do
    headers = {
      'Content-Type': 'application/json',
      'X-API-Key': user2.api_key
    }

    body = { target: 'A1' }.to_json

    post "/api/v1/games/#{game.id}/shots", headers: headers, params: body
    expect(response.status).to be(400)

    data = JSON.parse(response.body, symbolize_names: true)
    expect(data[:message]).to include('Invalid move. It\'s your opponent\'s turn')
  end
end
