require 'matrix'

class Game
  X = -1
  O = 1

  def initialize(n=3, with_move_validation=true)
    @n=n
    @total_moves = @n**2
    @winner = nil
    @validate_moves=with_move_validation
    @board = Array.new(@total_moves)
  end

  def board
    @board
  end

  def size
    @n
  end

  def []=(x,y,val)
    validate_value!(val)
    validate_num_moves! if @validate_moves
    @board[position(x,y)]=val
    check_winner(x,y,val)
  end

  def [](x,y)
    @board[position(x,y)]
  end

  def row(index)
    return enum_for(:row, index) unless block_given?
    0..@n.times do |i|
      yield self[index, i]
    end
  end

  def row_state(index)
    state = new_state
    row(index).to_a.each_with_index do |val, index|
      key = val.nil? ? :nils : val
      state[key] << index
    end
    state
  end

  def column(index)
    return enum_for(:column, index) unless block_given?
    0..@n.times do |i|
      yield self[i, index]
    end
  end

  def column_state(index)
    state = new_state
    column(index).to_a.each_with_index do |val, index|
      key = val.nil? ? :nils : val
      state[key] << index
    end
    state
  end

  def main_diagonal_state
    state = new_state
    main_diagonal.to_a.each_with_index do |val, index|
      key = val.nil? ? :nils : val
      state[key] << [index,index]
    end
    state
  end

  def anti_diagonal_state
    state = new_state
    anti_diagonal.to_a.each_with_index do |val, index|
      key = val.nil? ? :nils : val
      state[key] << [index,(@n-1)-index]
    end
    state
  end

  def main_diagonal
    return enum_for(:main_diagonal) unless block_given?
    0..@n.times do |i|
      yield self[i,i]
    end
  end

  def anti_diagonal
    return enum_for(:anti_diagonal) unless block_given?
    0..@n.times do |i|
      yield self[i,(@n-1)-i]
    end
  end

  def game_over?
    winner? || @total_moves == move_count
  end

  def moves_left
    @total_moves - move_count
  end

  def move_count
    @board.compact.count
  end

  def tie?
    game_over? && @winner.nil?
  end

  def winner?
    !!@winner
  end

  def winner
    @winner
  end

  def hash
    @board.to_s
  end

  def clone
    Marshal::load(Marshal.dump(self))
  end

  private
  def position(x,y)
    validate_coordinates!(x,y)
    (x*@n)+y
  end

  def validate_coordinates!(x,y)
    if x > @n-1 || y > @n-1
      raise ArgumentError
    end
  end

  def validate_value!(val)
    raise ArgumentError unless [X,O].include?(val)
  end

  def validate_num_moves!
    if @validate_moves && game_over?
      raise StandardError.new('Game over! Create new game to play again.')
    end

  end

  def check_winner(x,y,val)
    if row_winner?(x, val) || column_winner?(y, val) || (check_diagonals?(x,y) ? diagonal_winner?(val) : false)
      @winner = val
    end
  end

  def row_winner?(index, val)
    row(index).all? { |i| i == val }
  end

  def column_winner?(index, val)
    column(index).all? { |i| i == val }
  end

  def diagonal_winner?(val)
    main_diagonal.all? {|i| i == val } || anti_diagonal.all? {|i| i == val }
  end

  def check_diagonals?(x,y)
    double_val = (@n-1)*2
    [0,(@n-1), double_val].include?(x+y)
  end

  def new_state
    {Game::X => [], Game::O => [], nils:[]}.clone
  end



end