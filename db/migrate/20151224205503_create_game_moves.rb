class CreateGameMoves < ActiveRecord::Migration
  def change
    create_table :game_moves do |t|
      t.integer :x
      t.integer :y
      t.string :game_state
      t.string :end_type
      t.boolean :offense

      t.timestamps null: false
    end
  end
end
