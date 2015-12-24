class AIPlayer

  def initialize(marker)
    @my_marker = marker
    @their_marker = marker == Game::X ? Game::O : Game::X
  end

  def next_move(game)
    # gm = GameMove.order(end_type: :desc).find_by(game_state: game.hash)
    # [gm.x, gm.y]
    loss_moves = []
    game_moves = GameMove.where(:game_state => game.hash).order(end_type: :desc)
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

    return ties.first

  end



end
