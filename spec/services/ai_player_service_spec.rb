require 'rails_helper'

RSpec.describe AIPlayerService, :type => :model do

  it 'will find first critical as win and not block' do
    game = Game.new(3)
    game[0,0] = Game::X
    game[1,1] = Game::O
    game[2,2] = Game::X
    game[2,0] = Game::O
    game[0,2] = Game::X
    game[0,1] = Game::O
    move = AIPlayerService.find_first_critical(game,Game::X, Game::O)
    move.should == [1,2]
  end

end