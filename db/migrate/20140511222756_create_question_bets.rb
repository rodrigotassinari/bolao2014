class CreateQuestionBets < ActiveRecord::Migration
  def change
    create_table :question_bets do |t|
      t.integer :bet_id, null: false
      t.integer :question_id, null: false
      t.string :answer, null: false
      t.integer :points, null: false, default: 0

      t.timestamps
    end
    add_index :question_bets, :bet_id
    add_index :question_bets, :question_id
  end
end
