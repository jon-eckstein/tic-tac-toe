require 'rails_helper'

RSpec.describe AIPlayer, :type => :model do

  it 'will find first win space in row' do
    g = Game.new(3)
    g[0,0] = g[0,1] = Game::X
    player = AIPlayer.new(g, Game::X)
    player.find_first_critical.should == {win: [0,2]}
  end

  it 'will find first win space in column' do
    g = Game.new(3)
    g[1,0] = g[1,1] = Game::X
    player = AIPlayer.new(g, Game::X)
    player.find_first_critical.should == {win: [1,2]}
  end

  it 'will find first win in main diagonal' do
    g = Game.new(3)
    g[0,0] = g[1,1] = Game::X
    player = AIPlayer.new(g, Game::X)
    player.find_first_critical.should == {win: [2,2]}
  end

  it 'will find first win in anti diagonal' do
    g = Game.new(3)
    g[0,2] = g[2,0] = Game::X
    player = AIPlayer.new(g, Game::X)
    player.find_first_critical.should == {win: [1,1]}
  end

  it 'will find first block in row' do
    g = Game.new(3)
    g[0,0] = g[0,1] = Game::O
    player = AIPlayer.new(g, Game::X)
    player.find_first_critical.should == {block: [0,2]}
  end

  it 'will find first block in column' do
    g = Game.new(3)
    g[2,0] = g[2,1] = Game::O
    player = AIPlayer.new(g, Game::X)
    player.find_first_critical.should == {block: [2,2]}
  end


  it 'will get all possible combinations' do
    g = Game.new(3, false)
    player = AIPlayer.new(g, Game::X)

    h = player.train_as_offense
    puts h
  end

  it 'will open the root_move correctly' do
    thing = Marshal.load(File.read(Rails.root.join('db','moves_raw.dat').to_s))
    puts thing

  end

end