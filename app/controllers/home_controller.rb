class HomeController < ApplicationController


  def index
    g = Game.new(3)
    g[0,0] = Game::X
    session[:game] = g
    session[:ai_player] = AIPlayer.new(Game::X)
  end

end