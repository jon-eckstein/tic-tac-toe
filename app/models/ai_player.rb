class AIPlayer

  def initialize(marker)
    @my_marker = marker
    @their_marker = marker == Game::X ? Game::O : Game::X
  end

  def next_move(game, offense)
    if game.move_count == 0
      [0,0]
    else
      game_moves = GameMove.where(:game_state => game.hash, :offense => offense).order(end_type: :desc)
      #i need to cancel out all the moves that may result in a loss
      losses = Set.new(game_moves.select {|gm| gm.end_type == 'loss'}.map { |gm| [gm.x,gm.y] })
      wins = Set.new(game_moves.select {|gm| gm.end_type == 'win'}.map { |gm| [gm.x,gm.y] })
      ties = Set.new(game_moves.select {|gm| gm.end_type == 'tie'}.map { |gm| [gm.x,gm.y] })
      wins_no_losses = wins - losses
      if wins_no_losses.count > 0
        return wins_no_losses.first
      end
      ties_no_losses = ties - losses
      if ties_no_losses.count > 0
        return ties_no_losses.first
      end

      #if we're here that means it very early in the game and all combinations are possible
      #if on defense this is an important move. if x is on a corner, i need to be next to x..
      educated_guess(game,offense,ties)
    end

  end

  def educated_guess(game, offense, ties)
    if offense == false
      if opponent_on_corner(game)
        half = (game.size-1)/2
        if game[half,half] == nil
          return [half,half]
        end
      end

      if opponent_in_middle(game)
        corners(game).each do |corner|
          if game[corner[0], corner[1]] == nil
            return corner
          end
        end
      end
      #else pick randomly...
      ties.to_a.sample
    else
      ties.first
    end
  end

  def opponent_on_corner(game)
    corners(game).each do |corner|
      if game[corner[0], corner[1]] == @their_marker
        return true
      end
    end

    return false
  end

  def opponent_in_middle(game)
    half = (game.size-1)/2
    game[half,half]== @their_marker
  end

  def corners(game)
    size = game.size-1
    [[0,0], [0,size], [size,0], [size,size]]
  end

end
