require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  it 'can swap whose turn it is' do
    game = create(:game, player_1: user, player_2: user2)
    expect(game.current_turn).to eq("player_1")
    game.swap_turn!
    expect(game.current_turn).to eq("player_2")
    game.swap_turn!
    expect(game.current_turn).to eq("player_1")
  end

  it 'can detect a winner' do
    game = create(:game, player_1: user, player_2: user2)
    expect(game.won?).to be_nil
    game.player_2_ships = 0
    expect(game.won?).to be_truthy
    expect(game.winner).to eq(user.email)

    game = create(:game, player_1: user, player_2: user2)
    expect(game.won?).to be_nil
    game.player_1_ships = 0
    expect(game.won?).to be_truthy
    expect(game.winner).to eq(user2.email)
  end

  it 'can update sunken ships' do
    game = create(:game, player_1: user, player_2: user2)
    expect(game.player_2_ships).to be(2)
    game.sunken_ships
    expect(game.player_2_ships).to be(1)
  end
end
