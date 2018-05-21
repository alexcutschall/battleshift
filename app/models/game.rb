class Game < ApplicationRecord
  attr_accessor :messages
  belongs_to :player_1, class_name: 'User'
  belongs_to :player_2, class_name: 'User'

  #enum current_turn: ["challenger", "computer"]
  enum current_turn: [:player_1, :player_2]
  serialize :player_1_board
  serialize :player_2_board

  validates :player_1_board, presence: true
  validates :player_2_board, presence: true

  def swap_turn!
    if self.current_turn == "player_1"
     self.current_turn = "player_2"
    elsif self.current_turn == "player_2"
      self.current_turn = "player_1"
    end
  end

  def won?
    if self.player_1_ships == 0
      self.winner = self.player_2.email
    elsif self.player_2_ships == 0
      self.winner = self.player_1.email
    end
    self.save! unless self.winner.nil?
  end

  def sunken_ships
    if self.current_turn == "player_1"
      self.player_2_ships -= 1
    else self.current_turn == "player_2"
      self.player_1_ships -= 1
    end
    self.save!
  end

end
