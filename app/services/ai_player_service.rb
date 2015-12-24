class AIPlayerService

  def self.train_as_offense(game, player_marker, opponent_marker)
    stack = []
    win_moves = []
    tie_moves = []
    all_states = {}
    # g = Game.new(3,false)
    game[0,0] = player_marker
    my_turn = true
    root_move = {state: g.hash, game:g, my_turn: my_turn, move:[0,0], next_moves:[]}
    stack.push(root_move)
    pop_count=0
    while(move = stack.pop()) do
      pop_count +=1
      # puts "popping! -- stack size: #{stack.count}, pop_count #{pop_count}"
      x=0
      y=0
      my_turn = !move[:my_turn]
      while x <= move[:game].size-1 do
        while y <= move[:game].size-1 do
          if move[:game][x,y] == nil
            # gm = Marshal::load(Marshal.dump(move[:game]))
            gm = move[:game].clone
            gm[x,y] = my_turn ? player_marker : opponent_marker
            new_move = {state: move[:game].hash, game:gm, my_turn:my_turn, move:[x,y], next_moves:[], parent:move}
            # puts gm.board.to_s
            move[:next_moves] << new_move
            if gm.game_over?
              if gm.winner == player_marker
                win_moves << new_move
              end
              if gm.tie?
                tie_moves << new_move
              end
            else
              stack.push(new_move)
            end
          end
          y+=1
        end
        x+=1
        y=0
      end
    end


    GameMove.destroy_all
    puts "game_move count after destroy #{GameMove.count}"
    save_game_states(win_moves, :wins)
    puts 'completed wins'
    save_game_states(tie_moves, :ties)
    puts 'completed ties'

  end

  def self.save_game_states(moves, type)
    end_type = type == :wins ? 'win' : 'tie'

    moves.each do |move|
      ActiveRecord::Base.transaction do
        # if state_hash[move[:state]] == nil
        #   state_hash[move[:state]] = {wins:Set.new, ties:Set.new}
        # end
        # state_hash[move[:state]][type] << move[:move]

        # game_state = GameState.find_or_create_by(state:move[:state])
        # game_state.save!
        GameMove.find_or_create_by(x:move[:move][0], y:move[:move][1], game_state:move[:state], end_type:end_type)
        # gm.save!

        parent_move = move[:parent]
        # puts "parent_move: #{parent_move}"
        while parent_move != nil do
          if parent_move[:my_turn]
            # if state_hash[parent_move[:state]] == nil
            #   state_hash[parent_move[:state]] = {wins:Set.new, ties:Set.new}
            # end
            # state_hash[parent_move[:state]][type] << parent_move[:move]

            # gs = GameState.find_or_create_by(state:parent_move[:state])
            # gs.save!
            GameMove.find_or_create_by(x:parent_move[:move][0], y:parent_move[:move][1], game_state:parent_move[:state], end_type:end_type)
            # gm.save!

          end
          parent_move = parent_move[:parent]
        end
      end
    end

    # puts "done"
    # state_hash
  end

end