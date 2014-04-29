class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email,     null: false
      t.string :time_zone, null: false
      t.string :locale,    null: false

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :name,  unique: true
  end
end
