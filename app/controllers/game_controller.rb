class GameController < ApplicationController

  def move
    moves=[]
    if (move = params[:move])
      moves = move.split(',').map(&:to_i)
    end
    g = Game.from_hash(session[:game])
    g[moves[0],moves[1]] = Game::O
    next_move = AIPlayer.new(Game::X).next_move(g)
    g[next_move[0],next_move[1]] = Game::X
    session[:game] = g
    sleep(0.5)
    render json:{status: 'ok', ai_move: next_move.join(',')}
  end

end