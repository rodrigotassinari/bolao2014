class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.references :user, null: false
      t.integer :points, null: false, default: 0

      t.timestamps
    end
    add_index :bets, :user_id, unique: true
  end
end
