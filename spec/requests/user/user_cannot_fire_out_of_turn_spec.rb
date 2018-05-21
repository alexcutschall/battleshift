require 'rails_helper'

context 'A user posting to /api/v1/games/:id/shots out of turn' do
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
      req.headers['X-API-Key'] = ENV['BATTLESHIFT_API_KEY']
      req.body = {
        'ship_size': 2,
        'start_space': "A1",
        'end_space': "A2"
      }.to_json
    end
  end

  scenario 'is denied' do
    response = @conn.post do |req|
      req.url "/api/v1/games/#{@game_json[:id]}/shots"
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-API-Key'] = ENV['BATTLESHIFT_OPPONENT_API_KEY']
      req.body = { target: 'A1' }.to_json
    end

    expect(response.status).to be(400)

    data = JSON.parse(response.body, symbolize_names: true)
    expect(data[:message]).to include('Invalid move. It\'s your opponent\'s turn')
  end
end
