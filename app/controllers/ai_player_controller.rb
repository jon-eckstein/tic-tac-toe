class AiPlayerController < ApplicationController


  def train
    g = Game.new(3, false)
    player = AIPlayer.new(g, Game::X)
    player.train_as_offense
  end


end