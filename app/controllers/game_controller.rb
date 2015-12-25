class GameController < ApplicationController

  def move
    g = Game.from_hash(session[:game])
    offense = session[:offense] == true || session[:offense] == "true"
    my_token = offense ? Game::X : Game::O
    their_token = offense ? Game::O : Game::X
    next_move = nil

    if params[:move].present?
      moves = params[:move].split(',').map(&:to_i)
      g[moves[0],moves[1]] = their_token
    end

    unless g.game_over?
      next_move = AIPlayer.new(my_token).next_move(g, offense)
      g[next_move[0],next_move[1]] = my_token
      session[:game] = g
    end


    if g.game_over?
      state = g.winner? && g.winner == my_token ? 'win' : 'tie'
      payload = {game_over: true, state: state}
      payload.merge!(ai_move: next_move.join(',')) if next_move
      if state == 'win'
        payload.merge!({winning_series: g.winning_series.map{|i| "#{i[0]},#{i[1]}"}})
      end
      render json: payload
    else
      render json:{ai_move: next_move.join(',')}
    end

  end

  def new
    g = Game.new(3)
    session[:game] = g
    session[:offense] = params[:offense]
  end

end