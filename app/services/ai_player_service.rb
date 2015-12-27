class AIPlayerService

  def self.train_as_offense(game)
    stack = []
    win_moves = []
    tie_moves = []
    lost_moves = []
    player_marker = Game::X
    opponent_marker = Game::O
    offense=true

    #first move...
    hash = game.hash
    game[0,0] = player_marker
    my_turn = true
    root_move = {state: hash, game:game, my_turn: my_turn, move:[0,0]}
    stack.push(root_move)

    while(move = stack.pop()) do

      x=0
      y=0
      my_turn = !move[:my_turn]

      #if it's a critical move then we need to make it and no other moves should be considered in the path...
      if my_turn && (critical = find_first_critical(move[:game],player_marker, opponent_marker))
        gm = move[:game].clone
        gm[critical[0],critical[1]] = player_marker
        new_move = {state: move[:game].hash, game:gm, my_turn:my_turn, move:[critical[0],critical[1]], parent:move}
        determine_end_state(gm, player_marker, opponent_marker, win_moves, tie_moves, lost_moves, stack, new_move)
      else
        while x <= move[:game].size-1 do
          while y <= move[:game].size-1 do
            if move[:game][x,y] == nil
              gm = move[:game].clone
              gm[x,y] = my_turn ? player_marker : opponent_marker
              new_move = {state: move[:game].hash, game:gm, my_turn:my_turn, move:[x,y], parent:move}
              determine_end_state(gm, player_marker, opponent_marker, win_moves, tie_moves, lost_moves, stack, new_move)
            end
            y+=1
          end
          x+=1
          y=0
        end
      end

    end

    puts 'offense: combinations completed'

    GameMove.where(:offense=> offense).destroy_all
    save_game_states(win_moves, 'win', offense)
    puts 'offense: completed wins'
    save_game_states(tie_moves, 'tie', offense)
    puts 'offense: completed ties'
    save_game_states(lost_moves, 'loss', offense)
    puts 'offense: completed loss'
  end


  def self.train_as_defense(game)
    stack = []
    win_moves = []
    tie_moves = []
    lost_moves = []
    player_marker = Game::O
    opponent_marker = Game::X
    offense=false
    root_move = {state: game.hash, game:game, my_turn: true, move:nil}
    stack.push(root_move)

    while(move = stack.pop()) do
      x=0
      y=0
      my_turn = !move[:my_turn]

      #if it's a critical move then we need to make it a no other moves should be considered in the path...
      if my_turn && (critical = find_first_critical(move[:game],player_marker, opponent_marker))
        gm = move[:game].clone
        gm[critical[0],critical[1]] = player_marker
        new_move = {state: move[:game].hash, game:gm, my_turn:my_turn, move:[critical[0],critical[1]], parent:move}
        determine_end_state(gm, player_marker, opponent_marker, win_moves, tie_moves, lost_moves, stack, new_move)
      else
        while x <= move[:game].size-1 do
          while y <= move[:game].size-1 do
            if move[:game][x,y] == nil
              gm = move[:game].clone
              gm[x,y] = my_turn ? player_marker : opponent_marker
              new_move = {state: move[:game].hash, game:gm, my_turn:my_turn, move:[x,y], parent:move}
              determine_end_state(gm, player_marker, opponent_marker, win_moves, tie_moves, lost_moves, stack, new_move)
            end
            y+=1
          end
          x+=1
          y=0
        end
      end


    end

    puts 'defense: combinations completed'

    GameMove.where(:offense=> offense).destroy_all
    save_game_states(win_moves, 'win', offense)
    puts 'defense: completed wins'
    save_game_states(tie_moves, 'tie', offense)
    puts 'defense: completed ties'
    save_game_states(lost_moves, 'loss', offense)
    puts 'defense: completed loss'
  end


  def self.determine_end_state(gm, player_marker, opponent_marker, win_moves, tie_moves, lost_moves, stack, new_move)
    if gm.game_over?
      if gm.winner == player_marker
        win_moves << new_move
      end
      if gm.winner == opponent_marker
        lost_moves << new_move
      end
      if gm.tie?
        tie_moves << new_move
      end
    else
      stack.push(new_move)
    end
  end

  def self.save_game_states(moves, end_type, offense)

    moves.each do |move|
      ActiveRecord::Base.transaction do
        GameMove.find_or_create_by(x: move[:move][0], y: move[:move][1], game_state: move[:state], end_type: end_type, offense:offense)

        parent_move = move[:parent]

        while parent_move != nil do
          if parent_move[:my_turn] && parent_move[:move]
            GameMove.find_or_create_by(x: parent_move[:move][0], y: parent_move[:move][1], game_state: parent_move[:state], end_type: end_type, offense:offense)
          end
          parent_move = parent_move[:parent]
        end
      end
    end

    # puts "done"
  end

  def self.find_first_critical(game, my_marker, their_marker)
    #return a win move right away, otherwise save the block last move and remove the first at the end..
    last_block = nil
    0..game.size.times do |i|
      rs = game.row_state(i)
      critical_position = [i,rs[:nils].first]
      case
        when win_state?(rs, game, my_marker, their_marker)
          return critical_position
        when block_state?(rs, game, my_marker, their_marker)
          last_block = critical_position
      end

      cs = game.column_state(i)
      critical_position = [cs[:nils].first,i]
      case
        when win_state?(cs, game, my_marker, their_marker)
          return critical_position
        when block_state?(cs, game, my_marker, their_marker)
          last_block =  critical_position
      end
    end

    mds = game.main_diagonal_state
    case
      when win_state?(mds, game, my_marker, their_marker)
        return mds[:nils].first
      when block_state?(mds, game, my_marker, their_marker)
        last_block =  mds[:nils].first
    end

    ads = game.anti_diagonal_state
    case
      when win_state?(ads, game, my_marker, their_marker)
        return ads[:nils].first
      when block_state?(ads, game, my_marker, their_marker)
        last_block = ads[:nils].first
    end

    return last_block
  end

  def self.win_state?(state, game, my_marker, their_marker)
    state[my_marker].count == (game.size-1) && state[their_marker].count == 0
  end

  def self.block_state?(state, game, my_marker, their_marker)
    state[their_marker].count == (game.size-1) && state[my_marker].count == 0
  end


end