require 'rails_helper'

RSpec.describe Game, :type => :model do
  it 'creates new board on initialization' do
    g = Game.new
    expect(g.board).to_not be_nil
  end

  it 'persists a game move' do
    g = Game.new
    g[2,1] = Game::X
    g[2,1].should == Game::X
    g[0,0] = Game::O
    g[0,0].should == Game::O
  end

  it 'raises if index is out of bounds' do
    g = Game.new
    expect do
      g[5,2] = 9
    end.to raise_exception
  end

  it 'should track number of moves left' do
    g = Game.new(2)
    g[0,0] = Game::X
    g[1,0] = Game::O
    g.moves_left.should == 2
  end

  it 'should let track when game complete' do
    g = Game.new(2, false)
    g[0,0] = Game::X
    g[1,0] = Game::O
    g[0,1] = Game::X
    g[1,1] = Game::O
    g.moves_left.should == 0
  end

  it 'will return the correct row' do
    g = get_full_game
    g.row(0).to_a.should == [Game::X, Game::O, Game::X]
  end

  it 'will return the correct column' do
    g = get_full_game
    g.column(0).to_a.should == [Game::X, Game::O, Game::X]
  end

  it 'will return the correct main diagonal' do
    g = get_full_game
    g.main_diagonal.to_a.should == [Game::X, Game::X, Game::X]
  end

  it 'will return the correct anti diagonal' do
    g = get_full_game
    g.anti_diagonal.to_a.should == [Game::X, Game::X, Game::X]
  end

  it 'will return if row winner' do
    g = get_full_game
    g.winner?.should == true
    g.winner.should == Game::X
  end

  it 'will return correct main diagonal winner' do
    g = Game.new(3)
    g[0,0] = Game::O
    g[1,1] = Game::O
    g[2,2] = Game::O
    g.winner?.should == true
    g.winner.should == Game::O
  end

  it 'will return correct column winner' do
    g = Game.new(3)
    g[0,1] = Game::X
    g.winner?.should == false
    g[1,1] = Game::X
    g[2,1] = Game::X
    g.winner?.should == true
    g.winner.should == Game::X
  end

  def get_full_game
    g = Game.new(3, false)
    g[0,0] = Game::X
    g[0,1] = Game::O
    g[0,2] = Game::X

    g[1,0] = Game::O
    g[1,1] = Game::X
    g[1,2] = Game::O

    g[2,0] = Game::X
    g[2,1] = Game::O
    g[2,2] = Game::X

    g
  end


end