class AddShipsToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :player_1_ships, :integer, default: 2
    add_column :games, :player_2_ships, :integer, default: 2
  end
end
