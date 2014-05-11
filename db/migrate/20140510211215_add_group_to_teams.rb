class AddGroupToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :group, :string, limit: 1, null: false
    add_index :teams, :group
  end
end
