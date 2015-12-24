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
