module Api
  module V1
    class GamesController < ActionController::API
      def show
        begin
          game = Game.find(params[:id])
          render json: game
        rescue ActiveRecord::RecordNotFound
          render nothing: true, status: 400
        end
      end

      def create
        begin
          player_1 = User.find_by(api_key: request.env["HTTP_X_API_KEY"])
          render status: 400, message: 'Invalid API Key' and return if player_1.nil?
          player_2 = User.find_by(email: params["opponent_email"])
          render status: 400, message: 'Invalid opponnent email.' and return if player_2.nil?

          player_1_board = Board.new(4)
          player_2_board = Board.new(4)
          game = Game.create(player_1_id: player_1.id, player_2_id: player_2.id, player_1_board: player_1_board, player_2_board: player_2_board, player_1_turns: 0, player_2_turns: 0)

          render json: game
        rescue Exception => e
          #raise ActiveRecord::RecordNotFound
          raise e
        end
      end

    end
  end
end
