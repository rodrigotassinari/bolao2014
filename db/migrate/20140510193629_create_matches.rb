class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :number, null: false
      t.string :round, null: false
      t.string :group, limit: 1
      t.datetime :played_at, null: false
      t.string :played_on, null: false
      t.integer :team_a_id
      t.integer :team_b_id
      t.integer :goals_a
      t.integer :goals_b
      t.integer :penalty_goals_a
      t.integer :penalty_goals_b

      t.timestamps
    end
    add_index :matches, :number, unique: true
    add_index :matches, :round
    add_index :matches, :group
    add_index :matches, :team_a_id
    add_index :matches, :team_b_id
  end
end
