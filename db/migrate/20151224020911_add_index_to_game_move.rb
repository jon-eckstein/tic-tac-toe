class AddIndexToGameMove < ActiveRecord::Migration
  def change
    add_index :game_moves, [:x,:y,:game_state,:end_type], :unique=>true
  end
end
