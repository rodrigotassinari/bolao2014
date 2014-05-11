class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :team_id, null: false
      t.string :name, null: false
      t.string :position, null: false, default: 'field'

      t.timestamps
    end
    add_index :players, :team_id
    add_index :players, :position
  end
end
