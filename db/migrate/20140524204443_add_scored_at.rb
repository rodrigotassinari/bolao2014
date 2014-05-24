class AddScoredAt < ActiveRecord::Migration
  def change
    add_column :match_bets, :scored_at, :datetime
    add_index :match_bets, :scored_at
    add_column :question_bets, :scored_at, :datetime
    add_index :question_bets, :scored_at
  end
end
