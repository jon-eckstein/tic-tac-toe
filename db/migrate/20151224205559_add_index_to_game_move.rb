class AddIndexToGameMove < ActiveRecord::Migration
  def change
    add_index :game_moves, [:x, :y, :game_state, :end_type, :offense], :unique=>true, :name=>'index1'
  end
end
