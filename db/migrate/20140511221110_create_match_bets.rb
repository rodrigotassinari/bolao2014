class CreateMatchBets < ActiveRecord::Migration
  def change
    create_table :match_bets do |t|
      t.integer :bet_id, null: false
      t.integer :match_id, null: false
      t.integer :goals_a, null: false
      t.integer :goals_b, null: false
      t.integer :penalty_winner_id
      t.integer :points, null: false, default: 0

      t.timestamps
    end
    add_index :match_bets, :bet_id
    add_index :match_bets, :match_id
  end
end
