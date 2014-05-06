class AddAuthenticationFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :remember_me_token, :string, null: false
    add_column :users, :authentication_token, :string
    add_column :users, :authentication_token_expires_at, :datetime

    add_index :users, :remember_me_token, unique: true
    add_index :users, :authentication_token, unique: true
  end
end
