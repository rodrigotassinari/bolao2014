class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name_en, null: false
      t.string :name_pt, null: false
      t.string :acronym, null: false, limit: 3

      t.timestamps
    end
    add_index :teams, :name_en, unique: true
    add_index :teams, :name_pt, unique: true
    add_index :teams, :acronym, unique: true
  end
end
