class AIPlayer

  def initialize(game, marker)
    @game = game
    @my_marker = marker
    @their_marker = marker == Game::X ? Game::O : Game::X
    @my_points = 0
    @their_points = 0
  end

  def do_move()
    #if there's a critical move then make it...
    if (critical = find_first_critical)
      @game[critical[0],critical[1]] = @my_marker
    else
      #make a more strategic move


    end


  end

  def find_first_critical
    0..@game.size.times do |i|
      rs = @game.row_state(i)
      critical_position = [i,rs[:nils].first]
      case
        when win_state?(rs)
          return {win: critical_position}
        when block_state?(rs)
          return {block: critical_position}
      end

      cs = @game.column_state(i)
      critical_position = [rs[:nils].first,i]
      case
        when win_state?(cs)
          return {win: critical_position}
        when block_state?(cs)
          return {block: critical_position}
      end
    end

    mds = @game.main_diagonal_state
    case
      when win_state?(mds)
        return {win: mds[:nils].first}
      when block_state?(mds)
        return {block: mds[:nils].first}
    end

    ads = @game.anti_diagonal_state
    case
      when win_state?(ads)
        return {win: ads[:nils].first}
      when block_state?(ads)
        return {block: ads[:nils].first}
    end

    nil
  end

  def win_state?(state)
    state[@my_marker].count == (@game.size-1) && state[@their_marker].count == 0
  end

  def block_state?(state)
    state[@their_marker].count == (@game.size-1) && state[@my_marker].count == 0
  end

  def train_as_offense
    #method here will somehow create a tree from all possible game combinations...
    #will have to loop thru each possibility for each move...i mean, that's nuts...
    #assume the starting point is 0,0...then I need all possible moves for the next player...
    # 0,1  0,2  1,0  1,1  1,2  2,0  2,1  2,2
    stack = []
    win_moves = []
    tie_moves = []
    g = Game.new(3,false)
    g[0,0] = @my_marker
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
            gm[x,y] = my_turn ? @my_marker : @their_marker
            new_move = {state: gm.hash, game:gm, my_turn: my_turn, move:[x,y], next_moves:[], parent:move}
            # puts gm.board.to_s
            move[:next_moves] << new_move
            if gm.game_over?
              if gm.winner == @my_marker
                win_moves << new_move
              end
              if gm.tie?
                tie_moves << new_move
              end
            else
              stack.push(new_move) unless gm.game_over?
            end
          end
          y+=1
        end
        x+=1
        y=0
      end
    end


    return root_move, win_moves, tie_moves
  end

  # def next_move_set(root_move, my_turn)
  #   if @game.game_over?
  #     return
  #   end
  #   x=0
  #   y=1
  #   while x <= @game.size-1 do
  #     while y <= @game.size-1 do
  #       @game[x,y] = my_turn ? @my_marker : @their_marker
  #       new_move = {state: @game.hash, turn: my_turn, move:[x,y], next_moves:[]}
  #       root_move[:next_moves] << new_move
  #       next_move_set(new_move, !my_turn)
  #       y+=1
  #     end
  #     x+=1
  #     y=0
  #   end
  #
  # end

end
